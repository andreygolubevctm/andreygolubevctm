package com.ctm.energy.quote.request.model;


import java.util.Optional;

public class Electricity extends Energy {

    private ElectricityUsageDetails usageDetails;
    private  boolean hasSolarPanels;

    public Electricity(ElectricityUsageDetails usageDetails, HouseholdType householdType,
                       boolean hasBill, boolean hasSolarPanels, String currentSupplier) {
        super(householdType, hasBill, currentSupplier);
        this.usageDetails = usageDetails;
        this.hasSolarPanels = hasSolarPanels;
    }

    @SuppressWarnings("unused")
    private Electricity(){
        super();
    }

    @Override
    public Optional<UsageDetails> getUsageDetails() {
        return Optional.ofNullable(usageDetails);
    }

    public boolean isHasSolarPanels() {
        return hasSolarPanels;
    }
}
