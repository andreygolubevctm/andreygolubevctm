package com.ctm.model.leadfeed;

import java.util.Date;

/**
 * Generic container for CtM data
 *
 * Use to hold lead feed data before being converted to specific partner lead feed models.
 *
 */
public class LeadFeedData {

	public enum CallType {
		CALL_DIRECT("CallDirect"),
		GET_CALLBACK("GetaCall");

		private String callType;

		CallType(String callType) {
			this.callType = callType;
		}

		public String getCallType() {
			return callType;
		}

		public Boolean equals(String calltype) {
			return this.callType.equals(calltype);
		}
	};

	private CallType callType;

	private Date eventDate;

	private Integer brandId;
	private String brandCode;

	private Integer verticalId;
	private String verticalCode;

	private String clientName;

	private Long transactionId;

	private String phoneNumber = null;
	private String partnerReference;
	private String partnerBrand;

	private String state;
	private String vdn;

	private String clientIpAddress;

	private String productId = null;

	public LeadFeedData(){

	}

	public CallType getCallType() {
		return callType;
	}

	public void setCallType(CallType callType) {
		this.callType = callType;
	}

	public Date getEventDate() {
		return eventDate;
	}

	public void setEventDate(Date eventDate) {
		this.eventDate = eventDate;
	}

	public Integer getBrandId() {
		return brandId;
	}

	public void setBrandId(Integer brandId) {
		this.brandId = brandId;
	}

	public String getBrandCode() {
		return brandCode;
	}

	public void setBrandCode(String brandCode) {
		this.brandCode = brandCode;
	}

	public Integer getVerticalId() {
		return verticalId;
	}

	public void setVerticalId(Integer verticalId) {
		this.verticalId = verticalId;
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

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}
}
