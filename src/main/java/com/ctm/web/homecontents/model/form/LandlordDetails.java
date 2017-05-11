package com.ctm.web.homecontents.model.form;

public class LandlordDetails {
    private Integer numberOfTenants;
    private String propertyManagedBy;
    private boolean validRentalLease;
    private Integer weeklyRentValue;


    public Integer getNumberOfTenants() {
        return numberOfTenants;
    }

    public void setNumberOfTenants(Integer numberOfTenants) {
        this.numberOfTenants = numberOfTenants;
    }

    public String getPropertyManagedBy() {
        return propertyManagedBy;
    }

    public void setPropertyManagedBy(String propertyManagedBy) {
        this.propertyManagedBy = propertyManagedBy;
    }

    public boolean isValidRentalLease() {
        return validRentalLease;
    }

    public void setValidRentalLease(boolean validRentalLease) {
        this.validRentalLease = validRentalLease;
    }

    public Integer getWeeklyRentValue() {
        return weeklyRentValue;
    }

    public void setWeeklyRentValue(Integer weeklyRentValue) {
        this.weeklyRentValue = weeklyRentValue;
    }
}
