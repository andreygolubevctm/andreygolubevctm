package com.ctm.web.core.model;

import org.json.JSONException;
import org.json.JSONObject;

public class FormValidationLog extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "form_validation";

	private String xpath;
	private String validationMessage;
	private String textValue;
	private String stepId;
	/**
	 * The field name/xpath in data bucket.
	 * @return
	 */
	public String getXPath() {
		return xpath;
	}
	public void setXPath(String xpath) {
		this.xpath = xpath;
	}
	/**
	 * @return the validationMessage
	 */
	public String getValidationMessage() {
		return validationMessage;
	}
	/**
	 * @param validationMessage the validationRule to set
	 */
	public void setValidationMessage(String validationMessage) {
		this.validationMessage = validationMessage;
	}
	/**
	 * @return the textValue
	 */
	public String getTextValue() {
		return textValue;
	}
	/**
	 * @param textValue the textValue to set
	 */
	public void setTextValue(String textValue) {
		this.textValue = textValue;
	}

	/**
	 * @return the stepId
	 */
	public String getStepId() {
		return stepId;
	}
	/**
	 * @param stepId the stepId to set
	 */
	public void setStepId(String stepId) {
		this.stepId = stepId;
	}

	/**
	 * Add the attributes to the data model JSON object.
	 */
	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("xpath", getXPath());
		json.put("validationMessage", getValidationMessage());
		json.put("textValue", getTextValue());
		json.put("stepId", getStepId());

		return json;
	}


}
