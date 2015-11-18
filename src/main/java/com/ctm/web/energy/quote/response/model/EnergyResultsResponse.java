package com.ctm.web.energy.quote.response.model;

import com.ctm.web.core.model.resultsData.BaseResultObj;

import java.util.ArrayList;


public class EnergyResultsResponse extends BaseResultObj {

    private ArrayList<EnergyResultsPlanModel> plans;
    private String uniqueCustomerId;

    public ArrayList<EnergyResultsPlanModel> getPlans() {
        return plans;
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
}
