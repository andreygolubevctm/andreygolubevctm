package com.ctm.model;

import org.json.JSONException;
import org.json.JSONObject;

public class Address {

	private String unitType;
	private String unitNo;
	private String houseNo;
	private String FloorNo;
	private String street;
	private String suburb;
	private String postCode;
	private String state;

	public String getUnitType() {
		return unitType;
	}

	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}

	public String getUnitNo() {
		return unitNo;
	}

	public void setUnitNo(String unitNo) {
		this.unitNo = unitNo;
	}

	public String getHouseNo() {
		return houseNo;
	}

	public void setHouseNo(String houseNo) {
		this.houseNo = houseNo;
	}

	public String getFloorNo() {
		return FloorNo;
	}

	public void setFloorNo(String floorNo) {
		FloorNo = floorNo;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getSuburb() {
		return suburb;
	}

	public void setSuburb(String suburb) {
		this.suburb = suburb;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getPostCode() {
		return postCode;
	}

	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}

	public JSONObject toJSONObject() {
		JSONObject json = new JSONObject();
		try {
			json.put("unitType", getUnitType());
			json.put("unitNo", getUnitNo());
			json.put("houseNo", getHouseNo());
			json.put("floorNo", getFloorNo());
			json.put("street", getStreet());
			json.put("suburb", getSuburb());
			json.put("postCode", getPostCode());
			json.put("state", getState());
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return json;

	}

}
