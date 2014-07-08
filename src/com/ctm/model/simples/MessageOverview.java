package com.ctm.model.simples;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

/**
 * This model represents the simples.message_overview stored procedure.
 *
 */
public class MessageOverview extends AbstractJsonModel {
	private int current;
	private int pending;
	private int future;
	private int postponed;
	private int completed;
	private int expired;

	//
	// Accessors
	//

	public int getCurrent() {
		return current;
	}
	public void setCurrent(int current) {
		this.current = current;
	}

	public int getPending() {
		return pending;
	}
	public void setPending(int pending) {
		this.pending = pending;
	}

	public int getFuture() {
		return future;
	}
	public void setFuture(int future) {
		this.future = future;
	}

	public int getPostponed() {
		return postponed;
	}
	public void setPostponed(int postponed) {
		this.postponed = postponed;
	}

	public int getCompleted() {
		return completed;
	}
	public void setCompleted(int completed) {
		this.completed = completed;
	}

	public int getExpired() {
		return expired;
	}
	public void setExpired(int expired) {
		this.expired = expired;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("current", getCurrent());
		json.put("pending", getPending());
		json.put("future", getFuture());
		json.put("postponed", getPostponed());
		json.put("completed", getCompleted());
		json.put("expired", getExpired());

		return json;
	}
}
