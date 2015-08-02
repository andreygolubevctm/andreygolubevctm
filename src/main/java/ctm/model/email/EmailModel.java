package com.ctm.model.email;

public abstract class EmailModel {

	private String emailAddress;
	private String customerKey;
	private String clientName;
	private int clientId;
	private String env;
	private String mailingName;
	private String siteName;
	private String campaignName;
	private String brand;
	private String baseURL;
	private String subscriberKey;
	private String unsubscribeURL;
	private String imageUrlPrefix;

	public String getSubscriberKey() {
		return subscriberKey;
	}

	public void setSubscriberKey(String subscriberKey) {
		this.subscriberKey = subscriberKey;
	}

	public void setCustomerKey(String customerKey) {
		this.customerKey = customerKey;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public String getCustomerKey() {
		return this.customerKey;
	}

	public String getBaseURL() {
		return this.baseURL;
	}

	public String getBrand() {
		return this.brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getCampaignName(){
		return this.campaignName;
	}

	public int getClientId(){
		return this.clientId;
	}

	public String getClientName(){
		return this.clientName;
	}

	public String getEnv(){
		return this.env;
	}

	public String getMailingName(){
		return this.mailingName;
	}

	public String getSiteName(){
		return this.siteName;
	}

	public String getUnsubscribeURL() {
		return unsubscribeURL;
	}

	public void setUnsubscribeURL(String unsubscribeURL) {
		this.unsubscribeURL = unsubscribeURL;
	}

	public String getImageUrlPrefix() {
		return this.imageUrlPrefix;
	}

	public void setImageUrlPrefix(String imageUrlPrefix) {
		this.imageUrlPrefix = imageUrlPrefix;
	}


}
