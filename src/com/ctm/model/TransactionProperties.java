package com.ctm.model;

import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.formatter.JsonUtils;

/**
 * TransactionProperties model kind of glues {@link Transaction} to other related tables such as ctm.touches and ctm.quote_comments
 *
 * It is not the "transaction_details" of a transaction -- details should be vertical-specific e.g. {@link com.ctm.model.health.HealthTransaction}
 *
 */
public class TransactionProperties extends Transaction {

	private ArrayList<Comment> comments = new ArrayList<Comment>();
	private ArrayList<Touch> touches = new ArrayList<Touch>();



	public ArrayList<Comment> getComments() {
		return comments;
	}
	public void setComments(ArrayList<Comment> comments) {
		this.comments = comments;
	}

	public ArrayList<Touch> getTouches() {
		return touches;
	}
	public void setTouches(ArrayList<Touch> touches) {
		this.touches = touches;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = super.getJsonObject();

		// Add all the comments
		JsonUtils.addListToJsonObject(json, Comment.JSON_COLLECTION_NAME, getComments());

		// Add all the touches
		JsonUtils.addListToJsonObject(json, Touch.JSON_COLLECTION_NAME, getTouches());

		return json;
	}
}
