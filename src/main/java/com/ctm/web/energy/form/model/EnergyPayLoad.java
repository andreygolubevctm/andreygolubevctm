package com.ctm.web.energy.form.model;


import javax.validation.Valid;

public class EnergyPayLoad {

    public EnergyPayLoad(){

    }

    private HouseHoldDetails householdDetails;
    private String tariff;
    @Valid
    public ResultsDisplayed resultsDisplayed;
    private EstimateDetails estimateDetails;

    public void setTariff(String tariff) {
        this.tariff = tariff;
    }

    public void setResultsDisplayed(ResultsDisplayed resultsDisplayed) {
        this.resultsDisplayed = resultsDisplayed;
    }

    public void setEstimateDetails(EstimateDetails estimateDetails) {
        this.estimateDetails = estimateDetails;
    }


    public String getTariff() {
        return tariff;
    }

    public ResultsDisplayed getResultsDisplayed() {
        return resultsDisplayed;
    }

    public EstimateDetails getEstimateDetails() {
        return estimateDetails;
    }


    public HouseHoldDetails getHouseholdDetails() {
        return householdDetails;
    }

    public void setHouseholdDetails(HouseHoldDetails householdDetails) {
        this.householdDetails = householdDetails;
    }
}
