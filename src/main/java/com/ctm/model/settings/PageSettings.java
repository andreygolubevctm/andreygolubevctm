package com.ctm.model.settings;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.VerticalException;
import com.ctm.services.EnvironmentService;

public class PageSettings {

	private String brandCode;
	private int brandId;
	private Vertical vertical;

	public PageSettings() {

	}

	/**
	 * Returns a matching setting as a string
	 *
	 * @param name Setting key
	 */
	public String getSetting(String name) throws EnvironmentException, VerticalException, ConfigSettingException {
		if(vertical == null){
			throw new VerticalException("Vertical is null, environment: ["+getBrandCode()+":"+EnvironmentService.getEnvironmentAsString()+"]");
		}
		ConfigSetting setting = vertical.getSettingForName(name);
		if (setting == null) {
			throw new ConfigSettingException("Unable to find setting '" + name+"' for this brand, vertical, environment: ["+getBrandCode()+":"+getVerticalCode()+":"+EnvironmentService.getEnvironmentAsString()+"]");
		}
		return setting.getValue();
	}

	/**
	 * Check to see if a setting exists.
	 *
	 * @param name Setting key
	 */
	public boolean hasSetting(String name) throws EnvironmentException, VerticalException{
		try{
			getSetting(name);
			return true;
		}catch(ConfigSettingException e){
			return false;
		}
	}

	/**
	 * Returns a matching setting as an integer
	 * No error handling is in place. this will throw an exception if the value isn't an integer!
	 *
	 * @param name Setting key
	 */
	public int getSettingAsInt(String name) throws EnvironmentException, ConfigSettingException {
		String setting = getSetting(name);
		return Integer.parseInt(setting);
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
		return vertical.getType().getCode().toLowerCase();
	}

	public void setVertical(Vertical vertical) {
		this.vertical = vertical;
	}

	public String getRootUrl() throws EnvironmentException, VerticalException, ConfigSettingException {
		return getSetting("rootUrl");
	}

	public String getContextFolder() throws EnvironmentException, VerticalException, ConfigSettingException {
		String setting = getSetting("contextFolder");

		// In dev environments, check if the hard-coded context (configured in DB) can be overriden by
		// a feature branch context
		if (EnvironmentService.needsManuallyAddedBrandCodeParam()
				&& !setting.equals(EnvironmentService.getContextPath())
				&& EnvironmentService.getContextPath().regionMatches(0, setting, 0, setting.length()-1)) {
			return EnvironmentService.getContextPath();
		}
		else {
			return setting;
		}
	}

	public String getBaseUrl() throws EnvironmentException, VerticalException, ConfigSettingException {
		return getRootUrl()+getContextFolder();
	}

	public String getServerUrl() throws EnvironmentException, VerticalException, ConfigSettingException{
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
