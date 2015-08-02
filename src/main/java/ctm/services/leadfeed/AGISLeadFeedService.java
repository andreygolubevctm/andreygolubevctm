package com.ctm.services.leadfeed;

import java.io.IOException;
import java.util.List;

import com.ctm.interceptors.SpringWSLoggingInterceptor;
import com.ctm.model.settings.Vertical;
import com.ctm.services.*;
import com.ctm.xml.XMLOutputWriter;
import org.apache.log4j.Logger;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

import com.ctm.aglead.ws.MessageRequestService;
import com.ctm.aglead.ws.MessageResponseDetails;
import com.ctm.aglead.ws.PartnerHeader;
import com.ctm.aglead.ws.Request;
import com.ctm.aglead.ws.Response;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.model.Provider;
import com.ctm.services.leadfeed.LeadFeedService.LeadType;
import com.ctm.services.leadfeed.LeadFeedService.LeadResponseStatus;

public abstract class AGISLeadFeedService extends WebServiceGatewaySupport implements IProviderLeadFeedService{

	private static Logger logger = Logger.getLogger(AGISLeadFeedService.class.getName());

	/**
	 * getModel() is implemented by the extended lead feed class to construct the lead feed model.
	 *
	 * @return
	 */
	protected abstract AGISLeadFeedRequest getModel(LeadType leadType, LeadFeedData leadData) throws LeadFeedException;

	/**
	 * sendLeadFeedRequest() the base method called which generates a new lead feed.
	 *
	 */
	public LeadResponseStatus process(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {

		LeadResponseStatus feedResponse = LeadResponseStatus.FAILURE;
		try {

			if(leadType == LeadType.CALL_DIRECT) {
				// Return OK as we still want to record touches etc
				feedResponse = LeadResponseStatus.SUCCESS;
				logger.info("[Lead feed] Skipped sending lead to service as flagged to be ignored");
			} else {
				// Generate the lead feed model
				AGISLeadFeedRequest leadModel = getModel(leadType, leadData);
				// Get the relevant brand+vertical settings
				PageSettings pageSettings = SettingsService.getPageSettings(leadData.getBrandId(), leadData.getVerticalCode());
				Request feedRequest = createRequest(leadModel);
				Response response = this.request(pageSettings, feedRequest, leadModel.getServiceUrl(), leadData.getTransactionId());
				MessageResponseDetails responseDetails = response.getDetails();

				if(responseDetails.getStatus().equalsIgnoreCase("ok")){
					feedResponse = LeadResponseStatus.SUCCESS;
				}

				logger.info("[Lead feed] Response Status from AGIS: " + responseDetails.getStatus());
			}

		} catch (EnvironmentException | VerticalException | IOException e) {
			logger.error("[Lead feed] Exception adding lead feed message",e);
			throw new LeadFeedException(e.getMessage(), e);
		}

		return feedResponse;
	}

	protected AGISLeadFeedRequest addRequestsServiceProperties(AGISLeadFeedRequest model, LeadType leadType, LeadFeedData leadData) throws LeadFeedException {

		Provider provider;
		ServiceConfiguration serviceConfig;
		String serviceCode = null;

		if(leadType == LeadType.CALL_ME_BACK){
			serviceCode = LeadType.CALL_ME_BACK.getServiceUrlFlag();
		} else if(leadType == LeadType.BEST_PRICE){
			serviceCode = LeadType.BEST_PRICE.getServiceUrlFlag();
		} else if(leadType == LeadType.NOSALE_CALL){
			serviceCode = LeadType.NOSALE_CALL.getServiceUrlFlag();
		}

		try {
			provider = ProviderService.getProvider(leadData.getPartnerBrand(), ApplicationService.getServerDate());
			serviceConfig = ServiceConfigurationService.getServiceConfiguration(serviceCode, leadData.getVerticalId(), leadData.getBrandId());
		} catch (DaoException | ServiceConfigurationException e) {
			throw new LeadFeedException("[Lead feed] Could not load the required configuration for the " + leadData.getPartnerBrand() + " Lead Feed Service", e);
		}

		String serviceUrl = serviceConfig.getPropertyValueByKey("serviceUrl", leadData.getBrandId(), provider.getId(), Scope.SERVICE);
		String messageSource = serviceConfig.getPropertyValueByKey("messageSource", leadData.getBrandId(), provider.getId(), Scope.SERVICE);
		String messageText = serviceConfig.getPropertyValueByKey("messageText", leadData.getBrandId(), provider.getId(), Scope.SERVICE);
		String sourceId = serviceConfig.getPropertyValueByKey("sourceId", leadData.getBrandId(), provider.getId(), Scope.SERVICE);
		String partnerId = serviceConfig.getPropertyValueByKey("partnerId", leadData.getBrandId(), provider.getId(), Scope.SERVICE);

		model.setServiceUrl(serviceUrl);
		model.setMessageSource(messageSource);
		model.setMessageText(messageText);
		model.setSourceId(sourceId);
		model.setPartnerId(partnerId);

		return model;
	}

	/**
	 * createRequest()
	 * @return
	 */
	private Request createRequest(AGISLeadFeedRequest leadModel) {
		Request request = new Request();
		request.setHeader(getPartnerHeader(leadModel));
		request.setDetails(getMessageRequestService(leadModel));
		return request;
	}

	/**
	 * getPartnerHeader() generates a request header for request created above
	 * @return
	 */
	private PartnerHeader getPartnerHeader(AGISLeadFeedRequest leadModel) {
		PartnerHeader partnerHeader = new PartnerHeader();
		partnerHeader.setPartnerId(leadModel.getPartnerId());
		partnerHeader.setSourceId(leadModel.getSourceId());
		partnerHeader.setPartnerReference(leadModel.getPartnerReference());
		partnerHeader.setClientIpAddress(leadModel.getIPAddress());
		partnerHeader.setSchemaVersion(leadModel.getSchemaVersion());
		partnerHeader.setExtension(new PartnerHeader.Extension());
		return partnerHeader;
	}

	/**
	 * getMessageRequestService()
	 * @return
	 */
	private MessageRequestService getMessageRequestService(AGISLeadFeedRequest leadModel) {
		MessageRequestService messageRequestService = new MessageRequestService();
		messageRequestService.setRequestMessages(getRequestMessages(leadModel));
		return messageRequestService;
	}

	/**
	 * getRequestMessages()
	 * @return
	 */
	private MessageRequestService.RequestMessages getRequestMessages(AGISLeadFeedRequest leadModel) {
		MessageRequestService.RequestMessages requestMessages = new MessageRequestService.RequestMessages();
		List<MessageRequestService.RequestMessages.RequestMessage> messages = requestMessages.getRequestMessage();
		messages.add(getRequestMessage(leadModel));
		return requestMessages;
	}

	/**
	 * getRequestMessage()
	 * @return
	 */
	private MessageRequestService.RequestMessages.RequestMessage getRequestMessage(AGISLeadFeedRequest leadModel) {
		MessageRequestService.RequestMessages.RequestMessage requestMessage = new MessageRequestService.RequestMessages.RequestMessage();
		requestMessage.setCallBackDate(leadModel.getCallbackDate());
		requestMessage.setCallBackTime(leadModel.getCallbackTime());
		requestMessage.setClientName(leadModel.getClientName());
		requestMessage.setPhoneNumber(leadModel.getPhoneNumber());
		requestMessage.setClientNumber(leadModel.getClientNumber());
		requestMessage.setMessageText(leadModel.getMessageText());
		requestMessage.setMessageSource(leadModel.getMessageSource());
		requestMessage.setBrand(leadModel.getBrand());
		requestMessage.setVdn(leadModel.getVDN());
		requestMessage.setState(leadModel.getState());
		return requestMessage;
	}

	/**
	 * request()
	 * @param settings
	 * @param request
	 * @return
	 * @throws IOException
	 */
	public Response request(PageSettings settings,  Request request, String serviceUrl, Long transactionId) throws IOException {
		try {
			Jaxb2Marshaller marshaller = marshaller();
			setMarshaller(marshaller);
			setUnmarshaller(marshaller);
			logger.info("[Lead feed] Sending message to AGIS");

			// Log copy of XML Request/Response in Debug folders
			String path = "";
			if(settings.getVertical().getType() == Vertical.VerticalType.CAR){
				path = "get_prices/app-logs-debug";
			}else{
				path = settings.getVerticalCode()+"/app-logs-debug";
			}

			String fileName = "_AGIS_LEADFEED";
			if(transactionId != null) {
				fileName = transactionId + fileName;
			}
			XMLOutputWriter writer = new XMLOutputWriter(fileName, path);
			setInterceptors(new SpringWSLoggingInterceptor[]{ new SpringWSLoggingInterceptor(writer)});

			return (Response) getWebServiceTemplate().marshalSendAndReceive(serviceUrl, request);
		} catch (Exception e) {
			logger.error("[Lead feed] Exception sending lead feed message to AGIS",e);
			throw new IOException(e);
		}
	}

	/**
	 * marshaller()
	 * @return
	 */
	private Jaxb2Marshaller marshaller() {
		Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
		marshaller.setContextPaths("com.ctm.aglead.ws");
		return marshaller;
	}
}
