package com.ctm.energy.quote.request.model;


import java.util.Optional;

public class Gas extends Energy {

    private GasUsageDetails usageDetails;

    public Gas(GasUsageDetails usageDetails, HouseholdType householdType, boolean hasBill, String currentSupplier) {
        super(householdType, hasBill,currentSupplier);
        this.usageDetails = usageDetails;
    }

    @SuppressWarnings("unused")
    private Gas(){
        super();
    }


    @Override
    public Optional<UsageDetails> getUsageDetails() {
        return Optional.ofNullable(usageDetails);
    }
}
