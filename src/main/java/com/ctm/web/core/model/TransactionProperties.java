package com.ctm.web.core.model;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.web.core.model.formatter.JsonUtils;

/**
 * TransactionProperties model kind of glues {@link Transaction} to other related tables such as ctm.touches and ctm.quote_comments
 *
 * It is not the "transaction_details" of a transaction -- details should be vertical-specific e.g. {@link com.ctm.web.health.model.health.HealthTransaction}
 *
 */
public class TransactionProperties extends Transaction {

	@JsonProperty(Comment.JSON_COLLECTION_NAME)
	private List<Comment> comments = new ArrayList<>();

	@JsonProperty(Touch.JSON_COLLECTION_NAME)
	private List<Touch> touches = new ArrayList<>();

	@JsonProperty(MessageAudit.JSON_COLLECTION_NAME)
	private List<MessageAudit> audits = new ArrayList<>();



	public List<MessageAudit> getAudits() {
		return audits;
	}
	public void setAudits(List<MessageAudit> audits) {
		this.audits = audits;
	}

	public List<Comment> getComments() {
		return comments;
	}
	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}

	public List<Touch> getTouches() {
		return touches;
	}
	public void setTouches(List<Touch> touches) {
		this.touches = touches;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = super.getJsonObject();

		JsonUtils.addListToJsonObject(json, Comment.JSON_COLLECTION_NAME, getComments());
		JsonUtils.addListToJsonObject(json, Touch.JSON_COLLECTION_NAME, getTouches());
		JsonUtils.addListToJsonObject(json, MessageAudit.JSON_COLLECTION_NAME, getAudits());

		return json;
	}
}
