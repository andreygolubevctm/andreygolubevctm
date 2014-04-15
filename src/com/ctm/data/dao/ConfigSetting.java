package com.ctm.data.dao;


public class ConfigSetting {

	public static int ALL_VERTICALS = 0;
	public static int ALL_BRANDS = 0;
	public static String ALL_ENVIRONMENTS = "0";

	private String name;
	private String value;
	private int styleCodeId;
	private int verticalId;
	private String environment;


	public ConfigSetting(){

	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getValue() {
		return value;
	}


	public void setValue(String value) {
		this.value = value;
	}


	public int getStyleCodeId() {
		return styleCodeId;
	}


	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}


	public int getVerticalId() {
		return verticalId;
	}

	public void setVerticalId(int verticalId) {
		this.verticalId = verticalId;
	}

	public String getEnvironment() {
		return environment;
	}

	public void setEnvironment(String environment) {
		this.environment = environment;
	}

	public ConfigSetting clone(){
		ConfigSetting cloned = new ConfigSetting();
		cloned.setName(getName());
		cloned.setValue(getValue());
		cloned.setStyleCodeId(getStyleCodeId());
		cloned.setVerticalId(getVerticalId());
		cloned.setEnvironment(getEnvironment());
		return cloned;
	}

}
