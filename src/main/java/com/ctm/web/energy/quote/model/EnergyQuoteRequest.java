package com.ctm.web.energy.quote.model;

import com.ctm.web.energy.model.EnergyType;

import java.util.List;

public class EnergyQuoteRequest {

    private HouseholdDetails householdDetails;
    private List<EnergyType> energyTypes;
    private UsageDetails usageDetails;
    private SpendDetails spendDetails;
    private EstimateMethod estimateMethod;


    public HouseholdDetails getHouseholdDetails() {
        return householdDetails;
    }

    public List<EnergyType> getEnergyTypes() {
        return energyTypes;
    }

    public void setEnergyTypes(List<EnergyType> energyTypes) {
        this.energyTypes = energyTypes;
    }

    public void setHouseholdDetails(HouseholdDetails householdDetails) {
        this.householdDetails = householdDetails;
    }

    public UsageDetails getUsageDetails() {
        return usageDetails;
    }

    public void setUsageDetails(UsageDetails usageDetails) {
        this.usageDetails = usageDetails;
    }

    public SpendDetails getSpendDetails() {
        return spendDetails;
    }

    public void setSpendDetails(SpendDetails spendDetails) {
        this.spendDetails = spendDetails;
    }

    public EstimateMethod getEstimateMethod() {
        return estimateMethod;
    }

    public void setEstimateMethod(EstimateMethod estimateMethod) {
        this.estimateMethod = estimateMethod;
    }
}
