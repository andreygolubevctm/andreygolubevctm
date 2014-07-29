package com.ctm.model.car;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

public class CarBody extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "bodies";

	private String code;
	private String label;

	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}

	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("code", getCode());
		json.put("label", getLabel());

		return json;
	}
}
