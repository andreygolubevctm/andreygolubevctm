package com.ctm.model;

import java.util.Date;

import com.ctm.model.simples.DisplayDateSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.json.JSONException;
import org.json.JSONObject;

public class Comment extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "comments";

	private int id;
	private long transactionId;
	private String operator;
	private String comment;
	@JsonSerialize(using = DisplayDateSerializer.class)
	private Date datetime;

	//
	// Accessors
	//

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	public long getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}

	public Date getDatetime() {
		return datetime;
	}

	public void setDatetime(Date datetime) {
		this.datetime = datetime;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("id", getId());
		json.put("transactionId", getTransactionId());
		json.put("operator", getOperator());
		json.put("comment", getComment());
		json.put("datetime", getDatetime());

		return json;
	}
}
