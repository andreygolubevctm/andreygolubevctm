package com.ctm.web.energy.form.model;


public class HouseHoldDetails {

    public HouseHoldDetails(){

    }

    private String movingInDate;
    private WhatToCompare whatToCompare;
    private String postcode;
    private boolean isConnection; // true if moving to the property
    private String suburb;
    private YesNo movingIn;
    private String tariff;

    private YesNo recentGasBill;
    private YesNo recentElectricityBill;

    public  void setMovingInDate(String movingInDate) {
        this.movingInDate = movingInDate;
    }


    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getSuburb() {
        return suburb;
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
    }


    public boolean isConnection() {
        return isConnection;
    }

    public void setIsConnection(boolean isConnection) {
        this.isConnection = isConnection;
    }

    public WhatToCompare getWhatToCompare() {
        return whatToCompare;
    }

    public void setWhatToCompare(WhatToCompare whatToCompare) {
        this.whatToCompare = whatToCompare;
    }

    public YesNo getMovingIn() {
        return movingIn;
    }

    public void setMovingIn(YesNo movingIn) {
        this.movingIn = movingIn;
    }

    public String getTariff() {
        return tariff;
    }

    public void setTariff(String tariff) {
        this.tariff = tariff;
    }

    public String getMovingInDate() {
        return movingInDate;
    }


    public YesNo getRecentElectricityBill() {
        return recentElectricityBill;
    }

    public void setRecentElectricityBill(YesNo recentElectricityBill) {
        this.recentElectricityBill = recentElectricityBill;
    }

    public YesNo getRecentGasBill() {
        return recentGasBill;
    }

    public void setRecentGasBill(YesNo recentGasBill) {
        this.recentGasBill = recentGasBill;
    }
}
