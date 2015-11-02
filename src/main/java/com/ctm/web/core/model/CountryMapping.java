package com.ctm.web.core.model;

import org.json.JSONException;
import org.json.JSONObject;

/** This maps to provider_master table */

public class CountryMapping extends AbstractJsonModel{

	private String code;
	private int groupId;
	private String selectedCountries;
	private char hasCountries;
	private String selectedRegions;
	private char hasRegions;
	private String handoverMappings;
	private char hasHandoverValues;

	public CountryMapping(){

	}

	public String getProviderCode() {
		return code;
	}

	public void setProviderCode(String code) {
		this.code = code;
	}

	public int getProductGroup() {
		return groupId;
	}

	public void setProductGroup(int groupId) {
		this.groupId = groupId;
	}

	public String getSelectedCountries() {
		return selectedCountries;
	}
	public String getSelectedCountries(int limit) {
		String[] parts = selectedCountries.split(",");
		String newSelectedCountries = "", separator = "";

		if (parts.length > 1) {
			// figure out if the string is longer than the limit
			int maxIterations = parts.length < limit ? parts.length : limit;

			for (int i = 0; i < maxIterations; i++) {
				// getting fancy here by adding the word and if the number of countries returned is less than the limit. The and is appended just before the last country.
				// otherwise we'll use the , separator
				if (i == (maxIterations - 1) && (parts.length <= limit)) {
					separator = " and ";
				}
				newSelectedCountries += separator + parts[i];
				separator = ", ";
			}

			// if the number of countries exceeds the limit, we append the more ... copy
			if (parts.length > limit) {
				newSelectedCountries += " more ...";
			}
		} else {
			newSelectedCountries = parts[0];
		}

		return newSelectedCountries;
	}

	public void setSelectedCountries(String selectedCountries) {
		this.selectedCountries = selectedCountries;
	}

	public char getHasCountries() {
		return hasCountries;
	}

	public void setHasCountries(char hasCountries) {
		this.hasCountries = hasCountries;
	}

	public String getSelectedRegions() {
		return selectedRegions;
	}

	public void setSelectedRegions(String selectedRegions) {
		this.selectedRegions = selectedRegions;
	}

	public char getHasRegions() {
		return hasRegions;
	}

	public void setHasRegions(char hasRegions) {
		this.hasRegions = hasRegions;
	}

	public String getHandoverMappings() {
		return handoverMappings;
	}

	public void setHandoverMappings(String handoverMappings) {
		this.handoverMappings = handoverMappings;
	}

	public char getHasHandoverValues() {
		return hasHandoverValues;
	}

	public void setHasHandoverValues(char hasHandoverValues) {
		this.hasHandoverValues = hasHandoverValues;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
}
