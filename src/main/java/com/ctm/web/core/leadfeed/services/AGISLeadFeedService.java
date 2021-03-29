package com.ctm.web.core.leadfeed.services;

import com.ctm.aglead.ws.*;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.EnvironmentException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType;
import com.ctm.web.core.leadfeed.utils.LeadFeedUtil;
import com.ctm.web.core.logging.SpringWSLoggingInterceptor;
import com.ctm.web.core.logging.XMLOutputWriter;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ProviderService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.services.SettingsService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

import java.io.IOException;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.FAILURE;
import static com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.SUCCESS;

public abstract class AGISLeadFeedService extends WebServiceGatewaySupport implements IProviderLeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AGISLeadFeedService.class);

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

		LeadResponseStatus feedResponse = FAILURE;

		try {
			if(LeadFeedUtil.isServiceEnabled(leadType, leadData)) {
				// Generate the lead feed model
				AGISLeadFeedRequest leadModel = getModel(leadType, leadData);
				// Get the relevant brand+vertical settings
				PageSettings pageSettings = SettingsService.getPageSettings(leadData.getBrandId(), leadData.getVerticalCode());
				Request feedRequest = createRequest(leadModel);
				Response response = this.request(pageSettings, feedRequest, leadModel.getServiceUrl(), leadData.getTransactionId());
				MessageResponseDetails responseDetails = response.getDetails();

				if(responseDetails.getStatus().equalsIgnoreCase("ok")){
					feedResponse = SUCCESS;
				}

				LOGGER.debug("[Lead feed] Response Status from AGIS {}", kv("status", responseDetails.getStatus()));
			} else {
				// Return OK as we still want to record touches etc
				feedResponse = SUCCESS;
				LOGGER.warn("[Lead feed] Skipped sending lead to service as flagged to be ignored");
			}

		} catch (EnvironmentException | VerticalException | IOException e) {
			LOGGER.error("[Lead feed] Failed adding lead feed message {}", kv("leadData", leadData), e);
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
		} else if (leadType == LeadType.CALL_DIRECT) {
			serviceCode = LeadType.CALL_DIRECT.getServiceUrlFlag();
		}

		try {
			provider = ProviderService.getProvider(leadData.getPartnerBrand(), ApplicationService.getServerDate());
			serviceConfig = ServiceConfigurationService.getServiceConfiguration(serviceCode, leadData.getVerticalId());
		} catch (DaoException | ServiceConfigurationException e) {
			throw new LeadFeedException("[Lead feed] Could not load the required configuration for the " + leadData.getPartnerBrand() + " Lead Feed Service", e);
		}

		String serviceUrl = serviceConfig.getPropertyValueByKey("serviceUrl", leadData.getBrandId(), provider.getId(), Scope.SERVICE);


		String[] messageSources = StringUtils.split(
				serviceConfig.getPropertyValueByKey("messageSource", leadData.getBrandId(), provider.getId(), Scope.SERVICE),
				",");


		String messageText = serviceConfig.getPropertyValueByKey("messageText", leadData.getBrandId(), provider.getId(), Scope.SERVICE);
		String sourceId = serviceConfig.getPropertyValueByKey("sourceId", leadData.getBrandId(), provider.getId(), Scope.SERVICE);
		String partnerId = serviceConfig.getPropertyValueByKey("partnerId", leadData.getBrandId(), provider.getId(), Scope.SERVICE);

		model.setServiceUrl(serviceUrl);

		if (messageSources.length > 1) {
			if (leadData.isPartnerReferenceChange()) {
				model.setMessageSource(findMessageSource(messageSources, "partnerReferenceChange"));
			} else if (leadData.getMoreInfoProductCode() != null){
				model.setMessageSource(findMessageSource(messageSources, "moreInfoProduct"));
			} else {
				model.setMessageSource(messageSources[0]);
			}
		} else {
			model.setMessageSource(messageSources[0]);
		}

		model.setMessageText(messageText);
		model.setSourceId(sourceId);
		model.setPartnerId(partnerId);

		return model;
	}

	private String findMessageSource(String[] messageSources, String key) throws LeadFeedException {
		for (String messageSource : messageSources) {
			final String[] keyMessageSourceValue = StringUtils.split(messageSource, "=");
			if (StringUtils.equals(keyMessageSourceValue[0], key)) {
				return keyMessageSourceValue[1];
			}
		}
		throw new LeadFeedException("MessageSource not found for key " + key);
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
			LOGGER.debug("[Lead feed] Sending message to AGIS");

			// Log copy of XML Request/Response in Debug folders
			String path = settings.getVerticalCode()+"/app-logs-debug";

			String fileName = "_AGIS_LEADFEED";
			if(transactionId != null) {
				fileName = transactionId + fileName;
			}
			XMLOutputWriter writer = new XMLOutputWriter(fileName, path);
			setInterceptors(new SpringWSLoggingInterceptor[]{ new SpringWSLoggingInterceptor(writer)});

			return (Response) getWebServiceTemplate().marshalSendAndReceive(serviceUrl, request);
		} catch (Exception e) {
			LOGGER.error("[Lead feed] Failed sending lead feed message to AGIS {}, {}, {}", kv("settings", settings),
					kv("serviceUrl", serviceUrl), kv("transactionId", transactionId), e);
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
