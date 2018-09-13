package com.ctm.web.core.leadfeed.model;

import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;

/**
 * Generic container for CtM data
 *
 * Use to hold lead feed data before being converted to specific partner lead feed models.
 *
 */
public class LeadFeedData {

	public enum CallType {
		CALL_DIRECT("CallDirect"),
		GET_CALLBACK("GetaCall"),
		NOSALE_CALL("NoSaleCall");

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
	private String moreInfoProductCode;

	private String followupIntended;

	private boolean partnerReferenceChange;
	private String newPartnerReference;
	private String newPartnerBrand;
	private String newProductId = null;
	private Long rootId;
	//lead feed data for leads being sending to `ctm-leads` instead of AGI or others.
	private Person person;
	//any additional data which is not generic but required by specific lead feed service.
	private Object metadata;

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

	public String getMoreInfoProductCode() {
		return moreInfoProductCode;
	}

	public void setMoreInfoProductCode(String moreInfoProductCode) {
		this.moreInfoProductCode = moreInfoProductCode;
	}

	public String getFollowupIntended() {
		return followupIntended;
	}

	public void setFollowupIntended(final String followupIntended) {
		this.followupIntended = followupIntended;
	}

	public boolean isPartnerReferenceChange() {
		return partnerReferenceChange;
	}

	public void setPartnerReferenceChange(final boolean partnerReferenceChange) {
		this.partnerReferenceChange = partnerReferenceChange;
	}

	public String getNewPartnerReference() {
		return newPartnerReference;
	}

	public void setNewPartnerReference(final String newPartnerReference) {
		this.newPartnerReference = newPartnerReference;
	}

	public String getNewPartnerBrand() {
		return newPartnerBrand;
	}

	public void setNewPartnerBrand(final String newPartnerBrand) {
		this.newPartnerBrand = newPartnerBrand;
	}

	public String getNewProductId() {
		return newProductId;
	}

	public void setNewProductId(final String newProductId) {
		this.newProductId = newProductId;
	}

	public Long getRootId() {
		return rootId;
	}

	public void setRootId(Long rootId) {
		this.rootId = rootId;
	}

	public Person getPerson() {
		return person;
	}

	public void setPerson(Person person) {
		this.person = person;
	}

	public Object getMetadata() {
		return metadata;
	}

	public void setMetadata(Object metadata) {
		this.metadata = metadata;
	}

	@Override
	public String toString() {
		return "LeadFeedData{" +
				"callType=" + callType +
				", eventDate=" + eventDate +
				", brandId=" + brandId +
				", brandCode='" + brandCode + '\'' +
				", verticalId=" + verticalId +
				", verticalCode='" + verticalCode + '\'' +
				", clientName='" + clientName + '\'' +
				", transactionId=" + transactionId +
				", phoneNumber='" + phoneNumber + '\'' +
				", partnerReference='" + partnerReference + '\'' +
				", partnerBrand='" + partnerBrand + '\'' +
				", state='" + state + '\'' +
				", vdn='" + vdn + '\'' +
				", clientIpAddress='" + clientIpAddress + '\'' +
				", productId='" + productId + '\'' +
				", moreInfoProductCode='" + moreInfoProductCode + '\'' +
				", followupIntended='" + followupIntended + '\'' +
				", partnerReferenceChange=" + partnerReferenceChange +
				", newPartnerReference='" + newPartnerReference + '\'' +
				", newPartnerBrand='" + newPartnerBrand + '\'' +
				", newProductId='" + newProductId + '\'' +
				", rootId='" + rootId + '\'' +
				", person='" + person + '\'' +
				", metadata='" + metadata + '\'' +
				'}';
	}
}
