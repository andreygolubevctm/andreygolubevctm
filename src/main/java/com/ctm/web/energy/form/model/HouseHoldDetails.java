package com.ctm.web.energy.form.model;


public class HouseHoldDetails {

    private String whatToCompare;
    private String postcode;
    private boolean isConnection; // true if moving to the property
    private String suburb;
    private boolean solarPanels;
    private String howToEstimate;



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

    public boolean isSolarPanels() {
        return solarPanels;
    }

    public void setSolarPanels(boolean solarPanels) {
        this.solarPanels = solarPanels;
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
}
