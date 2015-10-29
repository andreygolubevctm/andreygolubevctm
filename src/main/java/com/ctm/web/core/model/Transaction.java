package com.ctm.web.core.model;

import com.ctm.model.AbstractJsonModel;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * The Transaction model is analogous to aggregator.transaction_header but not directly tied to it.
 * This should be considered the overarching model for transaction under which header/details/etc would sit.
 *
 */
public class Transaction extends AbstractJsonModel {

	private long transactionId;
	private long newestTransactionId;
	private long rootId;
	private String vertical;
	private int styleCodeId;
	private String styleCodeName;
	private String emailAddress;



	public long getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	/**
	 * The most-recent transaction ID in a chain of linked transactions.
	 * @return
	 */
	public long getNewestTransactionId() {
		return newestTransactionId;
	}
	public void setNewestTransactionId(long newestTransactionId) {
		this.newestTransactionId = newestTransactionId;
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

	public String getEmailAddress() {
		return emailAddress;
	}
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		// Transaction details
		json.put("transactionId", getTransactionId());
		json.put("newestTransactionId", getNewestTransactionId());
		json.put("rootId", getRootId());
		json.put("vertical", getVerticalCode());
		json.put("styleCodeId", getStyleCodeId());
		json.put("styleCodeName", getStyleCodeName());

		return json;
	}
}
