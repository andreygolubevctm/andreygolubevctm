package com.ctm.web.health.model;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.web.core.model.TransactionProperties;


public class HealthTransaction extends TransactionProperties {

	private boolean isConfirmed;
	private String confirmationKey;
	private String selectedProductTitle;
	private String selectedProductProvider;

	//
	// Accessors
	//
	public boolean getIsConfirmed() {
		return isConfirmed;
	}
	public void setIsConfirmed(boolean isConfirmed) {
		this.isConfirmed = isConfirmed;
	}

	public String getConfirmationKey() {
		return confirmationKey;
	}
	public void setConfirmationKey(String confirmationKey) {
		this.confirmationKey = confirmationKey;
	}

	public String getSelectedProductTitle() {
		return selectedProductTitle;
	}
	public void setSelectedProductTitle(String selectedProductTitle) {
		this.selectedProductTitle = selectedProductTitle;
	}

	public String getSelectedProductProvider() {
		return selectedProductProvider;
	}
	public void setSelectedProductProvider(String selectedProductProvider) {
		this.selectedProductProvider = selectedProductProvider;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = super.getJsonObject();

		// Transaction details
		json.put("isConfirmed", getIsConfirmed());
		json.put("confirmationKey", getConfirmationKey());
		json.put("selectedProductTitle", getSelectedProductTitle());
		json.put("selectedProductProvider", getSelectedProductProvider());

		return json;
	}
}
