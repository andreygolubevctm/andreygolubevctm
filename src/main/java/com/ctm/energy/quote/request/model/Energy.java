package com.ctm.energy.quote.request.model;


import java.util.Optional;

public abstract class Energy {

    private  boolean hasBill;
    private  String currentSupplier;
    private HouseholdType householdType;


    public Energy(HouseholdType householdType, boolean hasBill, String currentSupplier) {
        this.householdType = householdType;
        this.hasBill = hasBill;
        this.currentSupplier = currentSupplier;
    }

    protected Energy(){

    }


    public abstract Optional<UsageDetails> getUsageDetails();

    public boolean isHasBill() {
        return hasBill;
    }

    public String getCurrentSupplier() {
        return currentSupplier;
    }

    public HouseholdType getHouseholdType() {
        return householdType;
    }
}
