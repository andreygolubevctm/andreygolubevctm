package com.ctm.web.energy.model;

import com.ctm.web.core.resultsData.model.ResultsObj;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.energy.quote.response.model.EnergyResultsPlanModel;

import java.util.ArrayList;
import java.util.List;


public class EnergyResultsModel extends ResultsObj {

	private ArrayList<EnergyResultsPlanModel> plans = new ArrayList<EnergyResultsPlanModel>();
	private String uniqueCustomerId;
	private List<SchemaValidationError> validationErrors;

	public EnergyResultsModel(){

	}

	public void setPlans(ArrayList<EnergyResultsPlanModel> plans) {
		this.plans = plans;
	}


	public String getUniqueCustomerId() {
		return uniqueCustomerId;
	}

	public void setUniqueCustomerId(String uniqueCustomerId) {
		this.uniqueCustomerId = uniqueCustomerId;
	}

	public List<EnergyResultsPlanModel> getPlans() {
		return plans;
	}


	public void setValidationErrors(List<SchemaValidationError> validationErrors) {
		this.validationErrors = validationErrors;
	}

	public List<SchemaValidationError> getValidationErrors() {
		return validationErrors;
	}
}
