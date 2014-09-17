package com.ctm.model;

import java.util.HashMap;
import java.util.Map;


public class EmailDetails {

	private String lastName = "";
	private String firstName = "";
	private int emailId;
	private String emailAddress;
	private boolean valid;
	private String hashedEmail;
	private Map<String, Boolean> marketingOptIn = new HashMap<String, Boolean>();
	private long transactionId;

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
		return marketingOptIn.get(vertical);
	}

	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}
}
