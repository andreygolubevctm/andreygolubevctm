package com.ctm.web.core.model;

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

	private TouchProductProperty touchProductProperty;
	private TouchCommentProperty touchCommentProperty;
	private TouchLifebrokerProperty touchLifebrokerProperty;

	public TouchProductProperty getTouchProductProperty() {
		return touchProductProperty;
	}

	public void setTouchProductProperty(TouchProductProperty touchProductProperty) {
		this.touchProductProperty = touchProductProperty;
	}

	public TouchCommentProperty getTouchCommentProperty() {
		return touchCommentProperty;
	}

	public void setTouchCommentProperty(TouchCommentProperty touchCommentProperty) {
		this.touchCommentProperty = touchCommentProperty;
	}

	public TouchLifebrokerProperty getTouchLifebrokerProperty() {
		return touchLifebrokerProperty;
	}

	public void setTouchLifebrokerProperty(TouchLifebrokerProperty touchLifebrokerProperty) {
		this.touchLifebrokerProperty = touchLifebrokerProperty;
	}

	@JsonFormat(shape = JsonFormat.Shape.OBJECT)
	public static enum TouchType {
		BROCHURE ("Brochure sent" , "B", ""),
		NEW ("New quote" , "N", ""),
		SUBMITTED ("Submit", "P", ""),
		PRICE_PRESENTATION ("Price presentation" , "R", "'MIR'"),
		CALL_DIRECT_REQUEST("Call direct requested", "CDR", "'OHR','R','MIR'"),
		CALL_BACK_REQUEST("Call back requested", "CMR", "'CDR','OHR','R','MIR'"),
		ONLINE_HANDOVER_REQUEST("Online handover requested", "OHR", "'R','MIR'"),
		MORE_INFO_REQUEST("More info requested", "MIR", ""),
		ONLINE_HANDOVER("Online handover", "NPO", ""),
		APPLY ("Apply" ,"A", ""),
		FAIL ("Join failed" , "F", ""),
		SOLD ("Policy sold" , "C", ""),
		LOAD ("Load quote" , "L", ""),
		RESULTS_SINGLE ("Results single", "Q", ""),
		SAVE ("Saved quote" , "S", ""),
		GENERAL_HIT ("General hit", "H", ""),
		ERROR ("General error", "E", ""),
		TRANSFERRING ("Transferring", "T", ""),
		LEAD_CALL_ME_BACK("Call me back", "CB", ""),
		CALL_DIRECT("Call direct", "CD", ""),
		NOSALE_CALL("No Sale Call", "NS", ""),
		LEAD_BEST_PRICE("Best price", "BP", ""),
		LEAD_BEST_PRICE_DD("Best price DD", "BPDD", ""),
		LEAD_FEED("Lead feed", "LF", ""),
		CONTACT_DETAILS_COLLECTED("Contact details collected", "CDC", ""),
		CALL_FEED ("Call Feed" , "CF", ""), // Added to a call feed list.
		EMAIL_GATEWAY ("Email gateway", "EmlGateway", ""),
		CRON_ACTIONED("CRON Actioned", "CRON", ""),
		CONFIRMATION_VIEWED("Confirmation Page Viewed", "CONF", ""),
        MORE_INFO("More Info", "MoreInfo", ""),
		REMEMBER_ME("RememberMe","RememberMe", ""),
		BP_EMAIL_STARTED("Email sent started", "BPSTART", ""),
		BP_EMAIL_END("Email sent started", "BPEND", ""),
		SIMPLES_LIFEBROKER_LEAD("Simples Lead to Lifebroker", "SLBL", "");

		private final String description, code, overrides;

		TouchType(String description, String code, String overrides) {
			this.description = description;
			this.code = code;
			this.overrides = overrides;
		}

		public String getDescription() {
			return description;
		}
		public String getCode() {
			return code;
		}
		public String getOverrides() { return overrides; }
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
		// TODO: JSON Object for touchProperties
//		json.put("description", description);
		return json;
	}

	@Override
	public String toString() {
		return "Touch{" +
				"id=" + id +
				", transactionId=" + transactionId +
				", datetime=" + datetime +
				", operator='" + operator + '\'' +
				", type=" + type +
				", touchProductProperty=" + touchProductProperty +
				", touchCommentProperty=" + touchCommentProperty +
				'}';
	}
}
