package com.ctm.web.core.model;

import java.io.Serializable;

public class Unsubscribe implements Serializable {

	private static final long serialVersionUID = 1L;

	private String vertical;
	private EmailMaster emailDetails = new EmailMaster();

	/* #WHITELABEL TODO: support meerkat brand */
	private boolean meerkat;

	public boolean isMeerkat() {
		return meerkat;
	}

	public void setMeerkat(boolean meerkat) {
		this.meerkat = meerkat;
	}

	public EmailMaster getEmailDetails() {
		return emailDetails;
	}

	public void setVertical(String vertical) {
		this.vertical = vertical;
	}

	public String getVertical() {
		return vertical;
	}

	public void setEmailDetails(EmailMaster emailDetails) {
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
