package com.ctm.model.simples;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

/**
 * "Message" relates to the Call Centre message centre. This model represents the simples.message database table.
 *
 */
public class Message extends AbstractJsonModel {
	private int messageId;
	private long transactionId;
	private int userId;
	private int statusId;
	private String status;
	private String contactName;
	private String phoneNumber1;
	private String phoneNumber2;
	private String state;
	private boolean canPostpone;

	//
	// Accessors
	//

	public int getMessageId() {
		return messageId;
	}
	public void setMessageId(int messageId) {
		this.messageId = messageId;
	}

	public long getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getStatusId() {
		return statusId;
	}
	public void setStatusId(int statusId) {
		this.statusId = statusId;
	}

	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

	public String getPhoneNumber1() {
		return phoneNumber1;
	}
	public void setPhoneNumber1(String phoneNumber) {
		this.phoneNumber1 = phoneNumber;
	}

	public String getPhoneNumber2() {
		return phoneNumber2;
	}
	public void setPhoneNumber2(String phoneNumber) {
		this.phoneNumber2 = phoneNumber;
	}

	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}

	public boolean getCanPostpone() {
		return canPostpone;
	}
	public void setCanPostpone(boolean canPostpone) {
		this.canPostpone = canPostpone;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("messageId", getMessageId());
		json.put("transactionId", getTransactionId());
		json.put("userId", getUserId());
		json.put("statusId", getStatusId());
		json.put("status", getStatus());
		json.put("contactName", getContactName());
		json.put("phoneNumber1", getPhoneNumber1());
		json.put("phoneNumber2", getPhoneNumber2());
		json.put("state", getState());
		json.put("canPostpone", getCanPostpone());

		return json;
	}
}
