package com.ctm.model.car;

public class CarType {
	public static final String JSON_COLLECTION_NAME = "types";

	private String code;
	private String label;
	private int marketValue;

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

	public int getMarketValue() {
		return marketValue;
	}
	public void setMarketValue(int marketValue) {
		this.marketValue = marketValue;
	}

}
