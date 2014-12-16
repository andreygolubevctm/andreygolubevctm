package com.ctm.model;

import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

public class Touch extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "touches";

	private int id;
	private String transactionId;
	private Date datetime;
	private String operator;
	private TouchType type;

	public static String ONLINE_USER = "ONLINE";

	public static enum TouchType {
		NEW ("New quote" , "N"),
		UNLOCKED ("Unlocked", "X"),
		SUBMITTED ("Submit", "P"),
		PRICE_PRESENTATION("Price presentation" , "R"),
		APPLY("Apply" ,"A"),
		FAIL("Join failed" , "F"),
		SOLD("Policy sold" , "C"),
		LOAD("Load quote" , "L"),
		SAVE("Saved quote" , "S"),
		CALL_FEED("Call Feed" , "CF"); // Added to a call feed list.

		private final String description, code;

		TouchType(String description, String code) {
			this.description = description;
			this.code = code;
		}

		public String getDescription() {
			return description;
		}
		public String getCode() {
			return code;
		}

		/**
		 * Find a transmission type by its code.
		 * @param code Code e.g. R
		 */
		public static TouchType findByCode(String code) {
			for (TouchType t : TouchType.values()) {
				if (code.equals(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

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

	public TouchType getType() {
		return type;
	}

	public void setType(TouchType type) {
		this.type = type;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("transactionId", getTransactionId());
		json.put("operator", getOperator());
		String typeCode = "";
		if(getType() != null){
			typeCode = getType().getCode();
		}
		json.put("type", typeCode);
		json.put("datetime", getDatetime());

		return json;
	}
}
