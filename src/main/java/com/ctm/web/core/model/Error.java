package com.ctm.web.core.model;

import com.ctm.model.AbstractJsonModel;
import org.json.JSONException;
import org.json.JSONObject;

public class Error extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "errors";

	private String message;



	public Error() {
	}

	public Error(String message) {
		super();

		if (message == null) {
			message = "";
		}

		setMessage(message);
	}

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
