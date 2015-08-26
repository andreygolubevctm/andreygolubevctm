package com.ctm.model.utilities;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;


public class UtilitiesApplicationModel extends AbstractJsonModel {

	private static final Logger logger = LoggerFactory.getLogger(UtilitiesApplicationModel.class.getName());

	private String uniquePurchaseId;

	public UtilitiesApplicationModel(){

	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();
		json.put("uniquePurchaseId", getUniquePurchaseId());
		return json;
	}

	public boolean populateFromThoughtWorldJson(JSONObject responseJson) {

		try {
			setUniquePurchaseId(responseJson.getString("unique_purchase_id"));
		} catch (JSONException e) {
			logger.debug("{}",e.toString());
			return false;
		}

		return true;


	}

	public String getUniquePurchaseId() {
		return uniquePurchaseId;
	}

	public void setUniquePurchaseId(String uniquePurchaseId) {
		this.uniquePurchaseId = uniquePurchaseId;
	}

}
