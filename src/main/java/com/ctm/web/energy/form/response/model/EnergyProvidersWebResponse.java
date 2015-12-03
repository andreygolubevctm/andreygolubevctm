package com.ctm.web.energy.form.response.model;

import java.util.List;

public class EnergyProvidersWebResponse {

    private List<Provider> electricityProviders;

    private String electricityTariff;

    private List<Provider> gasProviders;

    public List<Provider> getElectricityProviders() {
        return electricityProviders;
    }

    public void setElectricityProviders(List<Provider> electricityProviders) {
        this.electricityProviders = electricityProviders;
    }

    public String getElectricityTariff() {
        return electricityTariff;
    }

    public void setElectricityTariff(String electricityTariff) {
        this.electricityTariff = electricityTariff;
    }

    public List<Provider> getGasProviders() {
        return gasProviders;
    }

    public void setGasProviders(List<Provider> gasProviders) {
        this.gasProviders = gasProviders;
    }
}
