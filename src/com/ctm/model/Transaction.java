package com.ctm.model;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * The Transaction model is analogous to aggregator.transaction_header but not directly tied to it.
 * This should be considered the overarching model for transaction under which header/details/etc would sit.
 *
 */
public class Transaction extends AbstractJsonModel {
	private static Logger logger = Logger.getLogger(Transaction.class.getName());

	private long transactionId;
	private long rootId;
	private String vertical;
	private int styleCodeId;
	private String styleCodeName;
	private ArrayList<Error> errors = new ArrayList<Error>();

	//
	// Accessors
	//
	public long getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public long getRootId() {
		return rootId;
	}
	public void setRootId(long rootId) {
		this.rootId = rootId;
	}

	public String getVerticalCode() {
		return vertical;
	}
	public void setVerticalCode(String vertical) {
		this.vertical = vertical;
	}

	public int getStyleCodeId() {
		return styleCodeId;
	}
	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}

	public String getStyleCodeName() {
		return styleCodeName;
	}
	public void setStyleCodeName(String styleCodeName) {
		this.styleCodeName = styleCodeName;
	}

	public ArrayList<Error> getErrors() {
		return errors;
	}
	public void addError(Error error) {
		errors.add(error);
	}



	@Override
	protected JSONObject getJsonObject() {
		JSONObject json = new JSONObject();
		JSONArray array = null;

		try {
			// Transaction details
			json.put("transactionId", getTransactionId());
			json.put("rootId", getRootId());
			json.put("vertical", getVerticalCode());
			json.put("styleCodeId", getStyleCodeId());
			json.put("styleCodeName", getStyleCodeName());
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
	}
}
