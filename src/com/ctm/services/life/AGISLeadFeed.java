package com.ctm.services.life;

import java.util.List;
import org.joda.time.LocalDate;
import org.joda.time.LocalTime;

import com.ctm.aglead.ws.MessageRequestService;
import com.ctm.aglead.ws.MessageResponseDetails;
import com.ctm.aglead.ws.PartnerHeader;
import com.ctm.aglead.ws.Request;
import com.ctm.aglead.ws.Response;
import com.ctm.model.life.Lead;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.AgLeadFeedService;

public class AGISLeadFeed {
	
	Lead lead;
	
	public static enum ProviderSourceID {
		BUDGET_DIRECT("0000000001"),
		OZICARE("0000000002");

		private final String id;

		ProviderSourceID(String id) {
			this.id = id;
		}

		public String getId() {
			return id;
		}
	}
	
	public static enum MessageSource {
		BEST_PRICE("LICTBESTPR"),
		REQUEST_CALLBACK("LICTCALLME"),
		FOLLOW_UP("LICTFOLLOW");

		private final String source;

		MessageSource(String source) {
			this.source = source;
		}

		public String getSource() {
			return source;
		}
	}
	
	public String newLeadFeed(PageSettings pageSettings, Lead lead) throws Exception {
		this.lead = lead;

		AgLeadFeedService agLeadFeedService = new AgLeadFeedService();
		agLeadFeedService.setTransactionId(lead.getPartnerReference());
		Request request = createRequest();
		Response response = agLeadFeedService.request(pageSettings, request);
		MessageResponseDetails responseDetails = response.getDetails();
		return responseDetails.getStatus();
	}
	
	private Request createRequest() {
		Request request = new Request();
		request.setHeader(getPartnerHeader());
		request.setDetails(getMessageRequestService());
		return request;
	}
	
	private PartnerHeader getPartnerHeader() {
        PartnerHeader partnerHeader = new PartnerHeader();
        partnerHeader.setPartnerId("CTM0000300");
        partnerHeader.setSourceId(lead.getSourceId());
        partnerHeader.setPartnerReference(lead.getPartnerReference());
        partnerHeader.setClientIpAddress(lead.getIpAddress());
        partnerHeader.setSchemaVersion("3.1");
        partnerHeader.setExtension(new PartnerHeader.Extension());
        return partnerHeader;
	}
	
	private MessageRequestService getMessageRequestService() {
        MessageRequestService messageRequestService = new MessageRequestService();
        messageRequestService.setRequestMessages(getRequestMessages());
        return messageRequestService;
	}
	
	private MessageRequestService.RequestMessages getRequestMessages() {
        MessageRequestService.RequestMessages requestMessages = new MessageRequestService.RequestMessages();
        List<MessageRequestService.RequestMessages.RequestMessage> messages = requestMessages.getRequestMessage();
        messages.add(getRequestMessage());
        return requestMessages;
	}
	
	private MessageRequestService.RequestMessages.RequestMessage getRequestMessage() {				
        MessageRequestService.RequestMessages.RequestMessage requestMessage = new MessageRequestService.RequestMessages.RequestMessage();
        requestMessage.setCallBackDate(new LocalDate());
        requestMessage.setCallBackTime(new LocalTime());
        requestMessage.setClientName(lead.getClientName());        
        requestMessage.setPhoneNumber(lead.getPhoneNumber());
        requestMessage.setClientNumber(lead.getLeadNumber());
        requestMessage.setMessageText(lead.getMessageText());
        requestMessage.setMessageSource(lead.getMessageSource());
        requestMessage.setBrand("");
        requestMessage.setVdn("");
        requestMessage.setState(lead.getState());
        return requestMessage;
	}
	
}
