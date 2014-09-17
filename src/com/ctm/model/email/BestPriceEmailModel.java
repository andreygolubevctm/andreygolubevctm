package com.ctm.model.email;

public abstract class BestPriceEmailModel extends EmailModel {
	private String emailAddress;
	private String firstName;
	private String lastName;
	private boolean optIn;
	private String premiumFrequency;
	private String callcentreHours;
	private String phoneNumber;

	public String getEmailAddress() {
		return emailAddress;
	}
	public String getFirstName() {
		return firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public boolean getOptIn() {
		return optIn;
	}
	public String getPremiumFrequency() {
		return premiumFrequency;
	}
	public String getCallcentreHours() {
		return callcentreHours;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public void setOptIn(boolean optIn) {
		this.optIn = optIn;
	}
	public void setPremiumFrequency(String premiumFrequency) {
		this.premiumFrequency = premiumFrequency;
	}
	public void setCallcentreHours(String callcentreHours) {
		this.callcentreHours = callcentreHours;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	@Override
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
		setSubscriberKey(emailAddress);
	}
}
