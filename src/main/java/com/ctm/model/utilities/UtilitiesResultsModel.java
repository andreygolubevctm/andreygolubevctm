package com.ctm.model.utilities;

import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;
import com.ctm.model.formatter.JsonUtils;


public class UtilitiesResultsModel extends AbstractJsonModel {

	private static final Logger logger = LoggerFactory.getLogger(UtilitiesResultsModel.class.getName());

	private ArrayList<UtilitiesResultsPlanModel> plans = new ArrayList<UtilitiesResultsPlanModel>();
	private String uniqueCustomerId;

	public UtilitiesResultsModel(){

	}
	public ArrayList<UtilitiesResultsPlanModel> getPlans() {
		return plans;
	}

	public void setPlans(ArrayList<UtilitiesResultsPlanModel> plans) {
		this.plans = plans;
	}


	@Override
	protected JSONObject getJsonObject() throws JSONException {

		JSONObject json = new JSONObject();
		JsonUtils.addListToJsonObject(json, "plans", getPlans());

		json.put("uniqueCustomerId", getUniqueCustomerId());

		return json;

	}

	public Boolean populateFromThoughtWorldJson(JSONArray json){
		try {

			for(int i = 0; i < json.length(); i++){

				JSONObject tempJson = json.getJSONObject(i);

				UtilitiesResultsPlanModel provider = new UtilitiesResultsPlanModel();
				provider.populateFromThoughtWorldJson(tempJson);

				if(getUniqueCustomerId() == null){
					setUniqueCustomerId(tempJson.getString("unique_customer_id"));
				}

				// perform validation
				if(provider.getAnnualNewCost() == 0 || provider.getPlanName().equals("")){
					logger.error("Missing field from result object");
					return false;
				}

				plans.add(provider);
			}


		} catch (JSONException e) {
			return false;
		}

		return true;

	}

	public String getUniqueCustomerId() {
		return uniqueCustomerId;
	}

	public void setUniqueCustomerId(String uniqueCustomerId) {
		this.uniqueCustomerId = uniqueCustomerId;
	}
}
