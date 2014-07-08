package com.ctm.model;

import org.json.JSONException;
import org.json.JSONObject;

public class Error extends AbstractJsonModel {
	private String message;

	//
	// Accessors
	//

	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("message", getMessage());

		return json;
	}
}
