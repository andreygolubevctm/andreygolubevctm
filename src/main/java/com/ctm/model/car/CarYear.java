package com.ctm.model.car;

public class CarYear {
	public static final String JSON_COLLECTION_NAME = "years";
	public static final String JSON_ALT_COLLECTION_NAME = "registrationYear";
	public static final String JSON_SINGLE_NAME = "year";

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
