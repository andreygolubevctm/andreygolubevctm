package com.ctm.data.dao;

import java.util.ArrayList;


public class Vertical {

	public static final String GENERIC_CODE = "GENERIC";
	private int id;
	private String code;
	private String name;
	private ArrayList<ConfigSetting> configSettings;

	public Vertical(){
		configSettings = new ArrayList<ConfigSetting>();
	}

	public ArrayList<ConfigSetting> getConfigSettings() {
		return configSettings;
	}

	public void setConfigSettings(ArrayList<ConfigSetting> configSettings) {
		this.configSettings = configSettings;
	}

	public void addSetting(ConfigSetting setting){
		// if duplicate, pick the most specific setting

		ConfigSetting existingSetting = getSettingForName(setting.getName());

		if(existingSetting != null){

			// Before adding a setting, compare with the existing setting.

			// Order of importance for comparison: ENVIRONMENT > BRAND > VERTICAL

			// Brand most important, then vertical
			if(existingSetting.getEnvironment().equals(ConfigSetting.ALL_ENVIRONMENTS) && setting.getEnvironment().equalsIgnoreCase(ConfigSetting.ALL_ENVIRONMENTS) == false){

				// The new setting has a more specific environment, use it instead.
				getConfigSettings().remove(existingSetting);
				getConfigSettings().add(setting);

			}else if(existingSetting.getEnvironment().equals(setting.getEnvironment())){

				// Settings are equal on environment, now check brand
				if(existingSetting.getStyleCodeId() == ConfigSetting.ALL_BRANDS && setting.getStyleCodeId() != ConfigSetting.ALL_BRANDS){

					// The new setting has a more specific brand, use it instead.
					getConfigSettings().remove(existingSetting);
					getConfigSettings().add(setting);

				}else if(existingSetting.getStyleCodeId() == setting.getStyleCodeId()){

					// Brands are equal, now check vertical
					if(existingSetting.getVerticalId() == ConfigSetting.ALL_VERTICALS && setting.getVerticalId() != ConfigSetting.ALL_VERTICALS){
						// The new setting has a more specific vertical, use it instead.
						getConfigSettings().remove(existingSetting);
						getConfigSettings().add(setting);
					}
				}
			}

		}else{
			getConfigSettings().add(setting);
		}

	}

	public ConfigSetting getSettingForName(String name){
		for(ConfigSetting setting : getConfigSettings()){
			if(setting.getName().equalsIgnoreCase(name)){
				return setting;
			}
		}
		return null;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Vertical clone(){
		Vertical cloned = new Vertical();
		cloned.setCode(getCode());
		cloned.setId(getId());
		cloned.setName(getName());
		return cloned;
	}

}
