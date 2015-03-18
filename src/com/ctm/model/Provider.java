package com.ctm.model;

import org.json.JSONException;
import org.json.JSONObject;

/** This maps to provider_master table */

public class Provider extends AbstractJsonModel{

	private int id;
	private String code;
	private String name;

	public Provider(){

	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}



}
