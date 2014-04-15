package com.ctm.data;

import com.ctm.data.dao.ConfigSetting;
import com.ctm.data.dao.Vertical;
import com.ctm.data.exceptions.ConfigSettingException;
import com.ctm.services.EnvironmentService;

public class PageSettings {

	private String brandCode;
	private Vertical vertical;

	public PageSettings() {

	}

	public String getSetting(String name) throws Exception {
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

}
