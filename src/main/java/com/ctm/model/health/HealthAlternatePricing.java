package com.ctm.model.health;

import org.json.JSONException;
import org.json.JSONObject;

public class HealthAlternatePricing {

	private Boolean isActive = null;
	private String fromMonth = null;
	private String[] disabledFunds = null;

	public HealthAlternatePricing() {}

	public HealthAlternatePricing(Boolean isActive, String fromMonth, String[] disabledFunds) {
		setIsActive(isActive);
		setFromMonth(fromMonth);
		setDisabledFunds(disabledFunds);
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public String getFromMonth() {
		return fromMonth;
	}

	public void setFromMonth(String fromMonth) {
		this.fromMonth = fromMonth;
	}

	public String[] getDisabledFunds() {
		return disabledFunds;
	}

	public void setDisabledFunds(String[] disabledFunds) {
		this.disabledFunds = disabledFunds;
	}

	public Boolean isProviderDisabled(String provider) {
		Boolean disabled = false;

		for(String fundCode : disabledFunds) {
			if(!fundCode.isEmpty() && fundCode.equalsIgnoreCase(provider)){
				disabled = true;
				continue;
			}
		}

		return disabled;
	}

	public JSONObject toJSON()  throws JSONException {
		JSONObject json = new JSONObject();
		json.put("isActive", isActive);
		json.put("fromMonth", fromMonth);
		json.put("disabledFunds", disabledFunds);
		return json;
	}
}
