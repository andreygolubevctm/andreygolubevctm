package com.ctm.web.validation;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

public class SchemaValidationError extends AbstractJsonModel {

	public static final String INVALID = "INVALID VALUE";
	public static final String REQUIRED = "ELEMENT REQUIRED";

	private String elementXpath;
	private String message;
	private String elements;

	public String getElementXpath() {
		return elementXpath;
	}

	public String getMessage() {
		return message;
	}

	public void setElementXpath(String elementXpath) {
		this.elementXpath = elementXpath;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void setElements(String elements) {
		this.elements = elements;
	}

	public String getElements() {
		return elements;
	}
	

	/**
	 * Add the attributes to the data model JSON object.
	 */
	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();
		json.put("message", getMessage());
		json.put("elementXpath", getElementXpath());
		json.put("elements", getElements());
		return json;
	}


}
