package com.ctm.energy.quote.response.model;


public class Retailer {

    private String retailerId;
    private String retailerName;

    public Retailer(String retailerId, String retailerName) {
        this.retailerId = retailerId;
        this.retailerName = retailerName;
    }

    @SuppressWarnings("unused")
    private Retailer(){

    }

    public String getRetailerId() {
        return retailerId;
    }

    public String getRetailerName() {
        return retailerName;
    }
}
