package com.ctm.web.core.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;


public class EmailMaster implements Cloneable, Serializable {

	private static final long serialVersionUID = 1L;

	private String lastName = "";
	private String firstName = "";
	private int emailId = 0;
	private String emailAddress;
	private boolean valid = false;
	private String hashedEmail;
	private Map<String, Boolean> marketingOptIn = new HashMap<>();
	private long transactionId;
	private String source;
	private String password;
	private String vertical;

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

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getVertical() {
		return vertical;
	}

	public void setVertical(String vertical) {
		this.vertical = vertical;
	}

	@Override
	public EmailMaster clone() {
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
		emailDetails.setPassword(password);
		emailDetails.setVertical(vertical);

		return emailDetails;
	}

	@Override
	public String toString() {
		return "EmailMaster{" +
				"lastName='" + lastName + '\'' +
				", firstName='" + firstName + '\'' +
				", emailId=" + emailId +
				", emailAddress='" + emailAddress + '\'' +
				", valid=" + valid +
				", hashedEmail='" + hashedEmail + '\'' +
				", marketingOptIn=" + marketingOptIn +
				", transactionId=" + transactionId +
				", source='" + source + '\'' +
				", password='" + password + '\'' + // password is hashed so this is safe to print and log
				'}';
	}
}
