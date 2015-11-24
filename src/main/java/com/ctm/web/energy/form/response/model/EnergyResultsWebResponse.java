package com.ctm.web.energy.form.response.model;

import com.ctm.web.core.providers.model.Response;

import java.util.ArrayList;
import java.util.List;


public class EnergyResultsWebResponse extends Response {


    private List<EnergyResultsPlanModel> plans = new ArrayList<>();
    private String uniqueCustomerId;

    public List<EnergyResultsPlanModel> getPlans() {
        return plans;
    }

    public void setPlans(List<EnergyResultsPlanModel> plans) {
        this.plans = plans;
    }

    public String getUniqueCustomerId() {
        return uniqueCustomerId;
    }

    public void setUniqueCustomerId(String uniqueCustomerId) {
        this.uniqueCustomerId = uniqueCustomerId;
    }
}
