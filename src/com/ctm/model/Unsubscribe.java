package com.ctm.model;

public class Unsubscribe {

	private String vertical;
	private EmailDetails emailDetails = new EmailDetails();

	/* #WHITELABEL TODO: support meerkat brand */
	private boolean meerkat;

	public boolean isMeerkat() {
		return meerkat;
	}

	public void setMeerkat(boolean meerkat) {
		this.meerkat = meerkat;
	}

	public EmailDetails getEmailDetails() {
		return emailDetails;
	}

	public void setVertical(String vertical) {
		this.vertical = vertical;
	}

	public String getVertical() {
		return vertical;
	}

	public void setEmailDetails(EmailDetails emailDetails) {
		this.emailDetails = emailDetails;
	}

	public boolean isValid() {
		return emailDetails.isValid();
	}

	public String getCustomerName() {
		return emailDetails.getName();
	}

	public String getCustomerEmail() {
		return emailDetails.getEmailAddress();
	}

}
