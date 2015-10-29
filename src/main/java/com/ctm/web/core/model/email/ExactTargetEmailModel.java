package com.ctm.web.core.model.email;

import java.util.HashMap;
import java.util.Map;

public class ExactTargetEmailModel {
	private Map<String , String> attributes = new HashMap<String, String>();

	private String brand;
	private String env;
	private String emailAddress;
	private int clientId;
	private String customerKey;
	private String subscriberKey;

	public Map<String, String> getAttributes() {
		return attributes;
	}
	public void setAttribute(String key, String value) {
		this.attributes.put(key, value);
	}

	protected String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getEnv() {
		return env;
	}
	public void setEnv(String env) {
		this.env = env;
	}
	public String getEmailAddress() {
		return emailAddress;
	}
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
		setAttribute("EmailAddress", emailAddress);
	}
	public int getClientId() {
		return clientId;
	}
	public void setClientId(int clientId) {
		this.clientId = clientId;
	}
	public String getCustomerKey() {
		return customerKey;
	}
	public void setCustomerKey(String customerKey) {
		this.customerKey = customerKey;
	}
	public void setSubscriberKey(String subscriberKey) {
		this.subscriberKey = subscriberKey;
		setAttribute("SubscriberKey", subscriberKey);
	}

	public String getSubscriberKey() {
		return subscriberKey;
	}
}
