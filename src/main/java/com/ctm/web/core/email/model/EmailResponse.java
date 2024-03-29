package com.ctm.web.core.email.model;

import com.ctm.web.core.model.AbstractJsonModel;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class EmailResponse extends AbstractJsonModel {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmailResponse.class);

	private String requestID;
	private String overallStatus;
	private boolean successful;
	private String message;
	private int errorCode;
	private Long transactionId;

	public int getErrorCode() {
		return errorCode;
	}

	public boolean isSuccessful() {
		return successful;
	}

	public String getMessage() {
		return message;
	}

	public EmailResponse() {
	}

	public EmailResponse(
		java.lang.String requestID,
		java.lang.String overallStatus) {
		this.requestID = requestID;
		this.overallStatus = overallStatus;
	}

	/**
	 * Gets the requestID value for this CreateResponse.
	 *
	 * @return requestID
	 */
	public java.lang.String getRequestID() {
		return requestID;
	}


	/**
	 * Sets the requestID value for this CreateResponse.
	 *
	 * @param requestID
	 */
	public void setRequestID(java.lang.String requestID) {
		this.requestID = requestID;
	}


	/**
	 * Gets the overallStatus value for this CreateResponse.
	 *
	 * @return overallStatus
	 */
	public java.lang.String getOverallStatus() {
		return overallStatus;
	}


	/**
	 * Sets the overallStatus value for this CreateResponse.
	 *
	 * @param overallStatus
	 */
	public void setOverallStatus(java.lang.String overallStatus) {
		this.overallStatus = overallStatus;
	}

	public  void setSuccessful(boolean successful) {
		this.successful = successful;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void setErrorCode(Integer errorCode) {
		this.errorCode = errorCode;
	}

	public void setTransactionId(Long transactionId) {
		this.transactionId = transactionId;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();
		try {
			json.put("success", successful);
			json.put("transactionId", transactionId);
			json.put("message", message);
		} catch (JSONException e) {
			LOGGER.error("error converting email response to json", e);
		}

		return json;
	}

}
