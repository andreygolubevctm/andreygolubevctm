package com.ctm.model.car;

public class CarMake {
	public static final String JSON_COLLECTION_NAME = "makes";
	public static final String JSON_DESCRIPTION_NAME = "makeDes";
	public static final String JSON_SINGLE_NAME = "make";

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
	
}
