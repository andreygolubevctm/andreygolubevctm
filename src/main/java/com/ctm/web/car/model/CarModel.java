package com.ctm.web.car.model;

public class CarModel {
	public static final String JSON_COLLECTION_NAME = "models";
	public static final String JSON_DESCRIPTION_NAME = "modelDes";
	public static final String JSON_SINGLE_NAME = "model";

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
	public void setIsTopModel(boolean isTopModel) {
		this.isTop = isTopModel;
	}


}
