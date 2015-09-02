package com.ctm.model.health.form;

public class Filter {

    private String priceMin;

    private String frequency;

    private String tierHospital;

    private String tierExtras;

    private String providerExclude;

    public String getPriceMin() {
        return priceMin;
    }

    public void setPriceMin(String priceMin) {
        this.priceMin = priceMin;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public String getTierHospital() {
        return tierHospital;
    }

    public void setTierHospital(String tierHospital) {
        this.tierHospital = tierHospital;
    }

    public String getTierExtras() {
        return tierExtras;
    }

    public void setTierExtras(String tierExtras) {
        this.tierExtras = tierExtras;
    }

    public String getProviderExclude() {
        return providerExclude;
    }

    public void setProviderExclude(String providerExclude) {
        this.providerExclude = providerExclude;
    }
}
