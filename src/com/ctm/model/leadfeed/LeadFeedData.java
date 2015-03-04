package com.ctm.model.leadfeed;

/**
 * Generic container for CtM data
 *
 * Use to hold lead feed data before being converted to specific partner lead feed models.
 *
 */
public class LeadFeedData {

	private String brandCode;
	private String verticalCode;

	private String clientName;

	private Long transactionId;

	private String phoneNumber;
	private String partnerReference;
	private String partnerBrand;

	private String state;
	private String vdn;

	private String clientIpAddress;

	public LeadFeedData(){

	}

	public String getBrandCode() {
		return brandCode;
	}

	public void setBrandCode(String brandCode) {
		this.brandCode = brandCode;
	}

	public String getVerticalCode() {
		return verticalCode;
	}

	public void setVerticalCode(String verticalCode) {
		this.verticalCode = verticalCode;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getPartnerReference() {
		return partnerReference;
	}

	public void setPartnerReference(String partnerReference) {
		this.partnerReference = partnerReference;
	}

	public String getPartnerBrand() {
		return partnerBrand;
	}

	public void setPartnerBrand(String partnerBrand) {
		this.partnerBrand = partnerBrand;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getVdn() {
		return vdn;
	}

	public void setVdn(String vdn) {
		this.vdn = vdn;
	}

	public Long getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(Long transactionId) {
		this.transactionId = transactionId;
	}

	public String getClientIpAddress() {
		return clientIpAddress;
	}

	public void setClientIpAddress(String clientIpAddress) {
		this.clientIpAddress = clientIpAddress;
	}

	public String getClientName() {
		return clientName;
	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}



}
