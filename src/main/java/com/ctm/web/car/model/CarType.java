package com.ctm.web.car.model;

public class CarType {
	public static final String JSON_COLLECTION_NAME = "types";
	public static final String JSON_MARKETVALUE_NAME = "marketValue";
	public static final String JSON_VARIANT_NAME = "variant";
	public static final String JSON_SINGLE_NAME = "type";

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
