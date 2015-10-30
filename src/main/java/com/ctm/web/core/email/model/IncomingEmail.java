package com.ctm.web.core.email.model;

import com.ctm.model.EmailMaster;
import com.ctm.web.core.model.email.EmailMode;

public class IncomingEmail {

	private EmailMode emailType = null;
	private String productId = null;
	private Long transactionId = null;
	private String campaignId = null;
	EmailMaster emailMaster = new EmailMaster();

	public IncomingEmail() {}

	public void setEmailType(EmailMode emailMode) {
		this.emailType = emailMode;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public void setTransactionId(Long transactionId) {
		this.transactionId = transactionId;
	}

	public void setEmailHash(String emailHash) {
		emailMaster.setHashedEmail(emailHash);
	}

	public void setCampaignId(String campaignId) {
		this.campaignId = campaignId;
	}

	public EmailMode getEmailType() {
		return this.emailType;
	}

	public String getProductId() {
		return this.productId;
	}

	public Long getTransactionId() {
		return this.transactionId;
	}

	public String getHashedEmail() {
		return emailMaster.getHashedEmail();
	}

	public String getCampaignId() {
		return this.campaignId;
	}

	public void setEmailAddress(String emailAddress) {
		emailMaster.setEmailAddress(emailAddress);
	}

	public EmailMaster getEmailMaster(){
		return emailMaster;
	}

	@Override
	public String toString() {
		return "IncomingEmail{" +
				"emailType=" + emailType +
				", productId='" + productId + '\'' +
				", transactionId=" + transactionId +
				", campaignId='" + campaignId + '\'' +
				", emailMaster=" + emailMaster +
				'}';
	}
}
