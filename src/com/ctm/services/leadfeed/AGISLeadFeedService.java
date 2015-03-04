package com.ctm.services.leadfeed;

import java.io.IOException;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

import com.ctm.aglead.ws.MessageRequestService;
import com.ctm.aglead.ws.MessageResponseDetails;
import com.ctm.aglead.ws.PartnerHeader;
import com.ctm.aglead.ws.Request;
import com.ctm.aglead.ws.Response;
import com.ctm.dao.TransactionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.TransactionProperties;
import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SettingsService;
import com.ctm.services.leadfeed.car.AGIS.AGISCarLeadFeedService.LeadType;

public abstract class AGISLeadFeedService extends WebServiceGatewaySupport{

	private static Logger logger = Logger.getLogger(AGISLeadFeedService.class.getName());


	/**
	 * getModel() is implemented by the extended lead feed class to construct the lead feed model.
	 *
	 * @return
	 */
	protected abstract AGISLeadFeedRequest getModel(LeadType leadType, LeadFeedData leadData);

	/**
	 * addLeadFeed() the base method called which generates a new lead feed.
	 *
	 */
	public String sendLeadFeedRequest(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {

		String feedResponse = null;
		try {
			// Generate the lead feed model
			AGISLeadFeedRequest leadModel = getModel(leadType, leadData);

			// Get the related transaction details (brand, vertical)
			TransactionDao transactionDao = new TransactionDao();
			TransactionProperties transactionProps = new TransactionProperties();
			transactionProps.setTransactionId(leadData.getTransactionId());
			transactionDao.getCoreInformation(transactionProps);

			// Get the relevant brand+vertical settings
			PageSettings pageSettings = SettingsService.getPageSettings(transactionProps.getStyleCodeId(), transactionProps.getVerticalCode());

			// Get to the business end of actioning the lead feed
			Request feedRequest = createRequest(leadModel);
			Response response = this.request(pageSettings, feedRequest);
			MessageResponseDetails responseDetails = response.getDetails();

			feedResponse = responseDetails.getStatus();

		} catch (DaoException | EnvironmentException | VerticalException | IOException e) {
			logger.error("[Lead feed] Exception adding lead feed message",e);
			throw new LeadFeedException(e.getMessage(), e);
		}

		return feedResponse;
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
	public Response request(PageSettings settings,  Request request) throws IOException {
		try {
			Jaxb2Marshaller marshaller = marshaller();
			String uri = settings.getSetting("agLeadFeedUrl");
			setMarshaller(marshaller);
			setUnmarshaller(marshaller);
			logger.info("[Lead feed] Sending message to AGIS");
			return (Response) getWebServiceTemplate().marshalSendAndReceive(uri, request);
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
