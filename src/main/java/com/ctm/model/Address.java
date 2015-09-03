package com.ctm.model;

import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Address {

	private String dpId;
	private String unitType;
	private String unitNo;
	private String houseNo;
	private String FloorNo;
	private String street;
	private String streetId;
	private String suburb;
	private String postCode;
	private String state;

	private static final Logger logger = LoggerFactory.getLogger(Address.class.getName());

	public String getDpId() {
		return dpId;
	}

	public void setDpId(String dpId) {
		this.dpId = dpId;
	}

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

	public String getStreetId() {
		return streetId;
	}

	public void setStreetId(String streetId) {
		this.streetId = streetId;
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
			json.put("dpId", getDpId());
			json.put("unitType", getUnitType());
			json.put("unitSel", getUnitNo());
			json.put("houseNoSel", getHouseNo());
			json.put("floorNo", getFloorNo());
			json.put("streetName", getStreet());
			json.put("streetId", getStreetId());
			json.put("suburbName", getSuburb());
			json.put("postCode", getPostCode());
			json.put("state", getState());
		} catch (JSONException e) {
			logger.error("Failed creating address json object", e);
		}

		return json;

	}

}
