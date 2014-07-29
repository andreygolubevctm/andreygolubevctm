package com.ctm.model;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * The Transaction model is analogous to aggregator.transaction_header but not directly tied to it.
 * This should be considered the overarching model for transaction under which header/details/etc would sit.
 *
 */
public class Transaction extends AbstractJsonModel {

	private long transactionId;
	private long rootId;
	private String vertical;
	private int styleCodeId;
	private String styleCodeName;

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



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		// Transaction details
		json.put("transactionId", getTransactionId());
		json.put("rootId", getRootId());
		json.put("vertical", getVerticalCode());
		json.put("styleCodeId", getStyleCodeId());
		json.put("styleCodeName", getStyleCodeName());

		return json;
	}
}
