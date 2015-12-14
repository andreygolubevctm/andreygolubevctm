package com.ctm.web.energy.apply.model.response;

public class ProductConfirmationData {

    private final String id;
    private final String retailerName;
    private final String planName;

    public ProductConfirmationData(String id, String retailerName, String planName) {
        this.id = id;
        this.retailerName = retailerName;
        this.planName = planName;
    }

    public String getId() {
        return id;
    }

    public String getRetailerName() {
        return retailerName;
    }

    public String getPlanName() {
        return planName;
    }
}
