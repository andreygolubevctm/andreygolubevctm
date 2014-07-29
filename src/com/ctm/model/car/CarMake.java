package com.ctm.model.car;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

public class CarMake extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "makes";

	private String code;
	private String label;
	private boolean isTopMake;

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

	public boolean getIsTopMake() {
		return isTopMake;
	}
	public void setIsTopMake(boolean isTopMake) {
		this.isTopMake = isTopMake;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("code", getCode());
		json.put("label", getLabel());
		json.put("isTopMake", getIsTopMake());

		return json;
	}
}
