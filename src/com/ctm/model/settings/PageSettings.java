package com.ctm.model.settings;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.services.EnvironmentService;

public class PageSettings {

	private String brandCode;
	private int brandId;
	private Vertical vertical;

	public PageSettings() {

	}

	public String getSetting(String name) throws EnvironmentException, ConfigSettingException {
		if(vertical == null){
			throw new ConfigSettingException("Vertical is null, environment: ["+getBrandCode()+":"+EnvironmentService.getEnvironmentAsString()+"]");
		}
		ConfigSetting setting = vertical.getSettingForName(name);
		if (setting == null) {
			throw new ConfigSettingException("Unable to find setting '" + name+"' for this brand, vertical, environment: ["+getBrandCode()+":"+getVerticalCode()+":"+EnvironmentService.getEnvironmentAsString()+"]");
		}
		return setting.getValue();
	}

	public String getBrandCode() {
		return brandCode.toLowerCase();
	}

	public void setBrandCode(String brandCode) {
		this.brandCode = brandCode;
	}

	public Vertical getVertical() {
		return vertical;
	}

	public String getVerticalCode() {
		return vertical.getCode().toLowerCase();
	}

	public void setVertical(Vertical vertical) {
		this.vertical = vertical;
	}

	public String getRootUrl() throws Exception{
		return getSetting("rootUrl");
	}

	public String getContextFolder() throws Exception{
		return getSetting("contextFolder");
	}

	public String getBaseUrl() throws Exception{
		return getRootUrl()+getContextFolder();
	}

	public String getServerUrl() throws Exception{
		return getSetting("serverUrl");
	}

	public int getBrandId() {
		return brandId;
	}

	public void setBrandId(int brandId) {
		this.brandId = brandId;
	}

	// The reason for not setting brand on the settings object is to reduce memory usage as the brand class contains a lot of content.
	public void setBrand(Brand brand){
		this.brandId = brand.getId();
		this.brandCode = brand.getCode();
	}

}
