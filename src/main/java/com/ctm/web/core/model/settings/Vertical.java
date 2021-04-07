package com.ctm.web.core.model.settings;

import java.util.ArrayList;



public class Vertical {

	public static enum VerticalType {
		GENERIC ("GENERIC"),
		ROADSIDE ("ROADSIDE"),
		TRAVEL ("TRAVEL"),
		HEALTH ("HEALTH"),
		FUEL ("FUEL"),
		SIMPLES ("SIMPLES"),
		COMPETITION ("COMPETITION");

		private final String code;

		VerticalType(String code) {
			this.code = code;
		}

		public String getCode() {
			return code;
		}

		/**
		 * Find a vertical type by its id.
		 * @param code Code e.g. P
		 */
		public static VerticalType findByCode(String code) {
			for (VerticalType t : VerticalType.values()) {
				if (code.equalsIgnoreCase(t.getCode())) {
					return t;
				}
			}
			return GENERIC;
		}
	}


	public static final int GENERIC_ID = 0;
	private int id;
	private String name;
	private int seq;
	private VerticalType type;
	private ArrayList<ConfigSetting> configSettings;

	public VerticalType getType() {
		return type;
	}

	public void setType(VerticalType type) {
		this.type = type;
	}

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

	public String getSettingValueForName(String name){
		ConfigSetting config = getSettingForName(name);
		return config != null ? config.getValue() : "";
	}

	public boolean isEnabled(){
		String verticalEnabledSetting = getSettingForName("status").getValue();

		if(verticalEnabledSetting.equals("Y") == false){
			return false;
		}

		return true;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getSequence() {
		return seq;
	}

	public void setSequence(int seq) {
		this.seq = seq;
	}

	public String getCode() {
		return getType().getCode();
	}


	public Vertical clone(){
		Vertical cloned = new Vertical();
		cloned.setType(getType());
		cloned.setId(getId());
		cloned.setName(getName());
		cloned.setSequence(getSequence());
		return cloned;
	}


}
