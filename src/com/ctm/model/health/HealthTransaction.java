package com.ctm.model.health;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.Error;
import com.ctm.model.TransactionProperties;


public class HealthTransaction extends TransactionProperties {
	private static Logger logger = Logger.getLogger(HealthTransaction.class.getName());

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
	protected JSONObject getJsonObject() {
		JSONObject json = super.getJsonObject();
		JSONArray array = null;

		try {
			// Transaction details
			json.put("isConfirmed", getIsConfirmed());
			json.put("confirmationKey", getConfirmationKey());
			json.put("selectedProductTitle", getSelectedProductTitle());
			json.put("selectedProductProvider", getSelectedProductProvider());
		}
		catch (JSONException e) {
			logger.error("Failed to produce JSON object", e);

			Error error = new Error();
			error.setMessage(e.getMessage());
			addError(error);
		}

		try {
			// Add any errors
			array = new JSONArray();
			for (Error error : getErrors()) {
				array.put(error.toJsonObject());
			}
			json.put("errors", array);
		}
		catch (JSONException e) {
			logger.error("Failed to produce JSON for the errors", e);
		}

		return json;
	}}
