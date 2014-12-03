package com.ctm.model.simples;

import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

/**
 * "MessageAudit" simples.message_audit database table.
 *
 */
public class MessageAudit extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "messageaudits";

	private int id;
	private int messageId;
	private int userId;
	private String operator;
	private Date created;
	private int statusId;
	private String status;
	private int reasonStatusId;
	private String reasonStatus;
	private String comment;

	//
	// Accessors
	//

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	public int getMessageId() {
		return messageId;
	}
	public void setMessageId(int messageId) {
		this.messageId = messageId;
	}

	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}

	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
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

	public int getReasonStatusId() {
		return reasonStatusId;
	}
	public void setReasonStatusId(int reasonStatusId) {
		this.reasonStatusId = reasonStatusId;
	}

	public String getReasonStatus() {
		return reasonStatus;
	}
	public void setReasonStatus(String reasonStatus) {
		this.reasonStatus = reasonStatus;
	}

	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("id", getId());
		json.put("messageId", getMessageId());
		json.put("userId", getUserId());
		json.put("operator", getOperator());
		json.put("created", getCreated());
		json.put("statusId", getStatusId());
		json.put("status", getStatus());
		json.put("reasonStatusId", getReasonStatusId());
		json.put("reasonStatus", getReasonStatus());
		json.put("comment", getComment());

		return json;
	}
}
