package com.ctm.web.homecontents.model.form;

public class LandlordDetails {
    private Integer numberOfTenants;
    private String propertyManagedBy;
    private Boolean ValidRentalLease;
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

    public Boolean getValidRentalLease() {
        return ValidRentalLease;
    }

    public void setValidRentalLease(Boolean validRentalLease) {
        ValidRentalLease = validRentalLease;
    }

    public Integer getWeeklyRentValue() {
        return weeklyRentValue;
    }

    public void setWeeklyRentValue(Integer weeklyRentValue) {
        this.weeklyRentValue = weeklyRentValue;
    }
}
