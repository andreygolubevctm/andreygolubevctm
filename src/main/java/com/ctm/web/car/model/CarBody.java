package com.ctm.web.car.model;

public class CarBody {
	public static final String JSON_COLLECTION_NAME = "bodies";
	public static final String JSON_SINGLE_NAME = "body";

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
