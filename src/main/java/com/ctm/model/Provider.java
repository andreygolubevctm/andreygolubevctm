package com.ctm.model;

import org.hibernate.validator.constraints.Range;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/** This maps to provider_master table */

public class Provider extends AbstractJsonModel{

	@Range(min=1, message="Provider ID must be positive Integer")
	private int id;
	private String code;
	private String name;
	Map<String, String> propertyDetails = new HashMap<>();

	public Provider(){

	}

	public Provider(int id, String code, String name) {
		this.id = id;
		this.code = code;
		this.name = name;
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

	public void setPropertyDetail(String propertyId, String value) {
		propertyDetails.put(propertyId, value);
	}

	public String getPropertyDetail(String propertyId) {
		return propertyDetails.get(propertyId);
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}



}
