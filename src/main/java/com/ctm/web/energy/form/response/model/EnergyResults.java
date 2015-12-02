package com.ctm.web.energy.form.response.model;

import java.util.ArrayList;
import java.util.List;


public class EnergyResults {

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
