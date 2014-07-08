package com.ctm.model;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * TransactionProperties model kind of glues {@link Transaction} to other related tables such as ctm.touches and ctm.quote_comments
 *
 * It is not the "transaction_details" of a transaction -- details should be vertical-specific e.g. {@link com.ctm.model.health.HealthTransaction}
 *
 */
public class TransactionProperties extends Transaction {
	private static Logger logger = Logger.getLogger(TransactionProperties.class.getName());

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
	protected JSONObject getJsonObject() {
		JSONObject json = super.getJsonObject();
		JSONArray array = null;

		try {
			// Add all the comments
			array = new JSONArray();
			for (Comment comment : getComments()) {
				array.put(comment.toJsonObject());
			}
			json.put("comments", array);

			// Add all the touches
			array = new JSONArray();
			for (Touch touch : getTouches()) {
				array.put(touch.toJsonObject());
			}
			json.put("touches", array);
		}
		catch (JSONException e) {
			logger.error("Failed to produce JSON object", e);

			Error error = new Error();
			error.setMessage(e.getMessage());
			addError(error);
		}

		try {
			// Add any errors
			array = new JSONArray();
			for (Error error : getErrors()) {
				array.put(error.toJsonObject());
			}
			json.put("errors", array);
		}
		catch (JSONException e) {
			logger.error("Failed to produce JSON for the errors", e);
		}

		return json;
	}
}
