package com.ctm.web.energy.quote.model;


public abstract class EstimateDetails {
    private String currentSupplier;

    public String getCurrentSupplier() {
        return currentSupplier;
    }

    public void setCurrentSupplier(String currentSupplier) {
        this.currentSupplier = currentSupplier;
    }
}
