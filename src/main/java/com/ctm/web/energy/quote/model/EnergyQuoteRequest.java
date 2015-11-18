package com.ctm.web.energy.quote.model;

import com.ctm.web.energy.model.UtilityType;

import java.util.List;

public class EnergyQuoteRequest {

    private ServiceAddress serviceAddress;
    private List<UtilityType> utilityTypes;
    private Utility electricity;
    private Utility gas;
    private EstimateMethod howToEstimate;


    public Utility getElectricity() {
        return electricity;
    }

    public void setElectricity(Utility electricity) {
        this.electricity = electricity;
    }

    public Utility getGas() {
        return gas;
    }

    public void setGas(Utility gas) {
        this.gas = gas;
    }

    public ServiceAddress getServiceAddress() {
        return serviceAddress;
    }


    public EstimateMethod getHowToEstimate() {
        return howToEstimate;
    }

    public void setHowToEstimate(EstimateMethod howToEstimate) {
        this.howToEstimate = howToEstimate;
    }

    public List<UtilityType> getUtilityTypes() {
        return utilityTypes;
    }

    public void setUtilityTypes(List<UtilityType> utilityTypes) {
        this.utilityTypes = utilityTypes;
    }

    public void setServiceAddress(ServiceAddress serviceAddress) {
        this.serviceAddress = serviceAddress;
    }
}
