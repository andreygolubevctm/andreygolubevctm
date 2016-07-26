package com.ctm.web.car.model;

public class CarMake {
	public static final String JSON_COLLECTION_NAME = "makes";
	public static final String JSON_DESCRIPTION_NAME = "makeDes";
	public static final String JSON_SINGLE_NAME = "make";

	private String code;
	private String label;
	private boolean isTop;

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

	public boolean getIsTop() {
		return isTop;
	}
	public void setIsTop(boolean isTop) {
		this.isTop = isTop;
	}
	
}
