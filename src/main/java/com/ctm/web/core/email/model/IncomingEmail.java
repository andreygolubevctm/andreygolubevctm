package com.ctm.web.core.email.model;

import com.ctm.web.core.model.EmailMaster;

public class IncomingEmail {

	private EmailMode emailType = null;
	private String productId = null;
	private Long transactionId = null;
	private String campaignId = null;
	private String etRid = null;
	private String utmSource = null;
	private String utmMedium = null;
	private String utmCampaign = null;
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

	public void setETRid(String etRid) {
		this.etRid = etRid;
	}

	public void setUTMSource(String utmSource) {
		this.utmSource = utmSource;
	}

	public void setUTMMedium(String utmMedium) {
		this.utmMedium = utmMedium;
	}

	public void setUTMCampaign(String utmCampaign) { this.utmCampaign = utmCampaign; }

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

	public String getETRid() {
		return this.etRid;
	}

	public String getUTMSource() {
		return this.utmSource;
	}

	public String getUTMMedium() {
		return this.utmMedium;
	}

	public String getUTMCampaign() {
		return this.utmCampaign;
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
				", et_rid='" + etRid + '\'' +
				", utm_source='" + utmSource + '\'' +
				", utm_medium='" + utmMedium + '\'' +
				", utm_campaign='" + utmCampaign + '\'' +
				", emailMaster=" + emailMaster +
				'}';
	}
}
