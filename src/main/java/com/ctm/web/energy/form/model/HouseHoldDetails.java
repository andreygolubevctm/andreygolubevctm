package com.ctm.web.energy.form.model;


public class HouseHoldDetails {

    private String movingInDate;
    private String whatToCompare;
    private String postcode;
    private boolean isConnection; // true if moving to the property
    private String suburb;
    private String howToEstimate;
    private String movingIn;
    private String tariff;
    private String solarPanels;

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

    public String getHowToEstimate() {
        return howToEstimate;
    }

    public void setHowToEstimate(String howToEstimate) {
        this.howToEstimate = howToEstimate;
    }

    public boolean isConnection() {
        return isConnection;
    }

    public void setIsConnection(boolean isConnection) {
        this.isConnection = isConnection;
    }

    public String getWhatToCompare() {
        return whatToCompare;
    }

    public void setWhatToCompare(String whatToCompare) {
        this.whatToCompare = whatToCompare;
    }

    public String getMovingIn() {
        return movingIn;
    }

    public void setMovingIn(String movingIn) {
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

    public  String getHasSolarPanels() {
        return solarPanels;
    }

    public void setSolarPanels(String solarPanels) {
        this.solarPanels = solarPanels;
    }
}
