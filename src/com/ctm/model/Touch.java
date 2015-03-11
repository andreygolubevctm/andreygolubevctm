package com.ctm.model;

import com.ctm.model.simples.DisplayDateSerializer;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Date;

public class Touch extends AbstractJsonModel {
	public static final String JSON_COLLECTION_NAME = "touches";

	private int id;
	private Long transactionId;
	@JsonSerialize(using = DisplayDateSerializer.class)
	private Date datetime;
	private String operator;
	private TouchType type;
	public static final String ONLINE_USER = "ONLINE";
	private String description;

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@JsonFormat(shape = JsonFormat.Shape.OBJECT)
	public static enum TouchType {
		BROCHURE ("Brochure sent" , "B"),
		NEW ("New quote" , "N"),
		UNLOCKED ("Unlocked", "X"),
		SUBMITTED ("Submit", "P"),
		PRICE_PRESENTATION ("Price presentation" , "R"),
		APPLY ("Apply" ,"A"),
		FAIL ("Join failed" , "F"),
		SOLD ("Policy sold" , "C"),
		LOAD ("Load quote" , "L"),
		SAVE ("Saved quote" , "S"),
		LEAD_CALL_ME_BACK("Call me back", "CB"),
		LEAD_BEST_PRICE("Best price", "BP"),
		CALL_FEED ("Call Feed" , "CF"); // Added to a call feed list.

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

	public Long getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(Long transactionId) {
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
		json.put("description", description);
		return json;
	}
}
