package com.ctm.model.leadfeed;

import org.joda.time.LocalDate;
import org.joda.time.LocalTime;

/**
 * Abstract model for any AGIS lead feed
 * This should be extended to build specific lead feed messages for each vertical.
 *
 */
public abstract class AGISLeadFeedRequest {

	private static int CLIENTNAME_CHAR_LIMIT = 30;

	protected String brandCode = "";

	// Header Fields
	protected String schemaVersion = "3.1";
	protected String serviceUrl;
	protected String partnerId;
	protected String sourceId;
	private String partnerReference;		// transactionId
	private String ipAddress;				// users ip address

	// Request Fields
	private String clientName;
	private String phoneNumber;
	private LocalDate callBackDate;
	private LocalTime callBackTime;
	private String messageSource;			// Reference to lead feed type eg CallDirect
	private String messageText = "";		// Message to send with lead feed
	private String clientNumber;			// Lead No. reference provided by providers service
	private String state = "";				// optional
	private String brand = "";				// optional
	private String vdn = "";				// optional

	public AGISLeadFeedRequest() {}

	public AGISLeadFeedRequest(LeadFeedData leadData) {
		importLeadData(leadData);
		setCallbackDate(new LocalDate());
		setCallbackTime(new LocalTime());
	}

	/**
	 * Populate the lead feed request from a standard CtM lead object.
	 * @param leadData
	 */
	public void importLeadData(LeadFeedData leadData){
		setPartnerReference(leadData.getTransactionId().toString());
		setIPAddress(leadData.getClientIpAddress());
		setClientName(leadData.getClientName());
		setPhoneNumber(leadData.getPhoneNumber());
		setClientNumber(leadData.getPartnerReference());
		setState(leadData.getState());
		setBrand(leadData.getPartnerBrand());
		setVDN(leadData.getVdn());
	}

	/** Header Accessors/Mutators **/

	public String getSchemaVersion() {
		return schemaVersion;
	}

	public void setSchemaVersion(String schemaVersion) {
		this.schemaVersion = schemaVersion;
	}

	public String getServiceUrl() {
		return serviceUrl;
	}

	public void setServiceUrl(String serviceUrl) {
		this.serviceUrl = serviceUrl;
	}

	public String getPartnerId() {
		return partnerId;
	}

	public void setPartnerId(String partnerId) {
		this.partnerId = partnerId;
	}

	public String getSourceId() {
		return sourceId;
	}

	public void setSourceId(String sourceId) {
		this.sourceId = sourceId;
	}

	public String getPartnerReference() {
		return partnerReference;
	}

	public void setPartnerReference(String partnerReference) {
		this.partnerReference = partnerReference;
	}

	public String getIPAddress() {
		return ipAddress;
	}

	public void setIPAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}

	/** Request Accessors/Modifiers **/

	public String getClientName() {
		return clientName;
	}

	public void setClientName(String clientName) {
		if(clientName != null) {
			StringBuilder output = new StringBuilder();
			nameBuilder : {
				for(String str : clientName.split(" ")) {
					// Exit if surname(s) makes name too long
					if(output.length() > 0 && (output.length() + str.length() + 1) > CLIENTNAME_CHAR_LIMIT) {
						break nameBuilder;
					// Append surname as is within limits
					} else if(output.length() > 0) {
						output.append(" " + str);
					// Append if name within limits
					} else if(str.length() <= CLIENTNAME_CHAR_LIMIT) {
						output.append(str);
					// Otherwise truncate the name and exit
					} else {
						output.append(str.substring(0, CLIENTNAME_CHAR_LIMIT));
						break nameBuilder;
					}
				}
			}
			clientName = output.toString();
		}
		this.clientName = clientName;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public LocalDate getCallbackDate() {
		return callBackDate;
	}

	public void setCallbackDate(LocalDate callBackDate) {
		this.callBackDate = callBackDate;
	}

	public LocalTime getCallbackTime() {
		return callBackTime;
	}

	public void setCallbackTime(LocalTime callBackTime) {
		this.callBackTime = callBackTime;
	}

	public String getMessageSource() {
		return messageSource;
	}

	public void setMessageSource(String messageSource) {
		this.messageSource = messageSource;
	}

	public String getMessageText() {
		return messageText;
	}

	public void setMessageText(String messageText) {
		this.messageText = messageText;
	}

	public String getClientNumber() {
		return clientNumber;
	}

	public void setClientNumber(String clientNumber) {
		this.clientNumber = clientNumber;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getVDN() {
		return vdn;
	}

	public void setVDN(String vdn) {
		this.vdn = vdn;
	}

	public String toString() {
		return "brandCode: " + brandCode + ", partnerReference: " + partnerReference + ", ipAddress: " + ipAddress + ", clientName: " + clientName + ", phoneNumber: " + phoneNumber + ", messageSource: " + messageSource + ", messageText: " + messageText + ", clientNumber: " + clientNumber + ", state: " + state + ", brand: " + brand + ", vdn: " + vdn;
	}
}
