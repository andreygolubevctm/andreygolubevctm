package com.ctm.model.utilities;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;


public class UtilitiesProviderModel extends AbstractJsonModel {

	// Flags
	private int id;
	private String name;


	// Getters & setters
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("id", getId());
		json.put("name", getName());

		return json;
	}
}
