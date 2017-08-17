package com.ctm.web.homecontents.model.form;

public class LandlordDetails {
    private Integer numberOfTenants;
    private String propertyManagedBy;
    private String validRentalLease;
    private Integer weeklyRentValue;
    private String pendingRentalLease;

    public String getPendingRentalLease() {
        return pendingRentalLease;
    }

    public void setPendingRentalLease(String pendingRentalLease) {
        this.pendingRentalLease = pendingRentalLease;
    }

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

    public String isValidRentalLease() {
        return validRentalLease;
    }

    public void setValidRentalLease(String validRentalLease) {
        this.validRentalLease = validRentalLease;
    }

    public Integer getWeeklyRentValue() {
        return weeklyRentValue;
    }

    public void setWeeklyRentValue(Integer weeklyRentValue) {
        this.weeklyRentValue = weeklyRentValue;
    }
}
