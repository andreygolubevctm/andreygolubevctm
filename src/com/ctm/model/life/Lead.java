package com.ctm.model.life;

import com.ctm.services.life.AGISLeadFeed;

public class Lead {

	private String sourceId;
	private String partnerReference;
	private String ipAddress;
	
	private String messageSource;
	private String messageText = "";
	
	private String clientName;
	private String phoneNumber;
	private String state;
	private String leadNumber;

	public String getClientName() {
		return clientName;
	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getLeadNumber() {
		return leadNumber;
	}

	public void setLeadNumber(String leadNumber) {
		this.leadNumber = leadNumber;
	}

	public String getSourceId() {
		return sourceId;
	}

	public void setSourceId(AGISLeadFeed.ProviderSourceID sourceId) {
		this.sourceId = sourceId.getId();
	}

	public String getPartnerReference() {
		return partnerReference;
	}

	public void setPartnerReference(String partnerReference) {
		this.partnerReference = partnerReference;
	}

	public String getIpAddress() {
		return ipAddress;
	}

	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}

	public String getMessageSource() {
		return messageSource;
	}

	public void setMessageSource(AGISLeadFeed.MessageSource messageSource) {
		this.messageSource = messageSource.getSource();
	}

	public String getMessageText() {
		return messageText;
	}

	public void setMessageText(String messageText) {
		this.messageText = messageText;
	}
	
}
