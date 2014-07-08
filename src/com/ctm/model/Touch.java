package com.ctm.model;

import java.util.Date;
import org.json.JSONException;
import org.json.JSONObject;

public class Touch extends AbstractJsonModel {

	private int id;
	private String transactionId;
	private Date datetime;
	private String operator;
	private String type;

	public Touch(){

	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	public Date getDatetime() {
		return datetime;
	}

	public void setDatetime(Date date) {
		this.datetime = date;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operatorId) {
		this.operator = operatorId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("transactionId", getTransactionId());
		json.put("operator", getOperator());
		json.put("type", getType());
		json.put("datetime", getDatetime());

		return json;
	}
}
