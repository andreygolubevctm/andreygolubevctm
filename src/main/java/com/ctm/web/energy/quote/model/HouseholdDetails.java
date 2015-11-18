package com.ctm.web.energy.quote.model;

import java.time.LocalDate;


public class HouseholdDetails {

    private String suburb;
    private String postCode;
    private boolean movingIn;
    private LocalDate movingInDate;
    private boolean hasSolarPanels;
    private String tariff;

    public String getSuburb() {
        return suburb;
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
    }

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }

    public boolean isMovingIn() {
        return movingIn;
    }

    public void setMovingIn(boolean movingIn) {
        this.movingIn = movingIn;
    }

    public LocalDate getMovingInDate() {
        return movingInDate;
    }

    public void setMovingInDate(LocalDate movingInDate) {
        this.movingInDate = movingInDate;
    }

    public boolean isHasSolarPanels() {
        return hasSolarPanels;
    }

    public void setHasSolarPanels(boolean hasSolarPanels) {
        this.hasSolarPanels = hasSolarPanels;
    }

    public String getTariff() {
        return tariff;
    }

    public void setTariff(String tariff) {
        this.tariff = tariff;
    }
}
