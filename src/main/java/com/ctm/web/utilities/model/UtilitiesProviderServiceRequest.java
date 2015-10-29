package com.ctm.web.utilities.model;

import com.ctm.model.AbstractJsonModel;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;


public class UtilitiesProviderServiceRequest extends AbstractJsonModel {

	private String postcode;
	private String suburb;


	public String getPostcode() {
		return postcode;
	}
	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getSuburb() {
		return suburb;
	}
	public void setSuburb(String suburb) {
		this.suburb = suburb;
	}

	public void populateFromRequest(HttpServletRequest request){
		String value;

		value = request.getParameter("postcode");
		if (value != null) {
			setPostcode(value);
		}

		value = request.getParameter("suburb");
		if (value != null) {
			setSuburb(value);
		}
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("postcode", this.getPostcode());
		json.put("suburb", this.getSuburb());

		return json;
	}
}
