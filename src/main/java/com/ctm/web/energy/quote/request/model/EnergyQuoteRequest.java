package com.ctm.web.energy.quote.request.model;

import com.ctm.web.energy.model.EnergyType;

import java.util.List;
import java.util.Optional;

public class EnergyQuoteRequest {

    private HouseholdDetails householdDetails;
    private List<EnergyType> energyTypes;
    private Optional<UsageDetails> usageDetails;
    private Optional<SpendDetails> spendDetails;
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

    public EstimateMethod getEstimateMethod() {
        return estimateMethod;
    }

    public void setEstimateMethod(EstimateMethod estimateMethod) {
        this.estimateMethod = estimateMethod;
    }

    public Optional<UsageDetails> getUsageDetails() {
        return usageDetails;
    }

    public void setUsageDetails(Optional<UsageDetails> usageDetails) {
        this.usageDetails = usageDetails;
    }

    public Optional<SpendDetails> getSpendDetails() {
        return spendDetails;
    }

    public void setSpendDetails(Optional<SpendDetails> spendDetails) {
        this.spendDetails = spendDetails;
    }
}
