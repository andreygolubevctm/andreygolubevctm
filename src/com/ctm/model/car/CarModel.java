package com.ctm.model.car;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

public class CarModel extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "models";

	private String code;
	private String label;
	private boolean isTopModel;

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

	public boolean getIsTopModel() {
		return isTopModel;
	}
	public void setIsTopModel(boolean isTopModel) {
		this.isTopModel = isTopModel;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("code", getCode());
		json.put("label", getLabel());
		json.put("isTopModel", getIsTopModel());

		return json;
	}
}
