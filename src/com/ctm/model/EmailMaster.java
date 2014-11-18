package com.ctm.model;

import java.util.HashMap;
import java.util.Map;


public class EmailMaster {

	private String lastName = "";
	private String firstName = "";
	private int emailId;
	private String emailAddress;
	private boolean valid = false;
	private String hashedEmail;
	private Map<String, Boolean> marketingOptIn = new HashMap<String, Boolean>();
	private long transactionId;
	private String source;

	public Map<String, Boolean> getMarketingOptIn() {
		return marketingOptIn;
	}

	public void setMarketingOptIn(Map<String, Boolean> marketingOptIn) {
		this.marketingOptIn = marketingOptIn;
	}

	public String getSource() {
		return source;
	}

	public String getLastName() {
		return lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public long getTransactionId() {
		return transactionId;
	}

	public int getEmailId() {
		return emailId;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public boolean isValid() {
		return valid;
	}

	public String getName() {
		if(lastName.isEmpty()) {
			return firstName;
		} else {
			return firstName  + " " + lastName;
		}
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setEmailId(int emailId) {
		this.emailId = emailId;
	}

	public void setValid(boolean valid) {
		this.valid= valid;
	}

	public String getHashedEmail() {
		return hashedEmail;
	}

	public void setHashedEmail(String hashedEmail) {
		this.hashedEmail = hashedEmail;
	}

	public void setOptedInMarketing(boolean optedIn, String vertical) {
		marketingOptIn.put(vertical , optedIn);
	}

	public boolean getOptedInMarketing(String vertical) {
		boolean optedIn = false;
		if(marketingOptIn.containsKey(vertical)){
			optedIn = marketingOptIn.get(vertical);
		}

		return optedIn;
	}

	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public EmailMaster copy() {
		EmailMaster emailDetails = new EmailMaster();
		emailDetails.setEmailAddress(emailAddress);
		emailDetails.setEmailId(emailId);
		emailDetails.setFirstName(firstName);
		emailDetails.setHashedEmail(hashedEmail);
		emailDetails.setLastName(lastName);
		emailDetails.setMarketingOptIn(marketingOptIn);
		emailDetails.setSource(source);
		emailDetails.setTransactionId(transactionId);
		emailDetails.setValid(valid);
		return emailDetails;
	}
}
