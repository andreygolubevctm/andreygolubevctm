package com.ctm.web.car.model;

public class CarColour {
	public static final String JSON_COLLECTION_NAME = "colours";
	public static final String JSON_SINGLE_NAME = "colour";

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

}
