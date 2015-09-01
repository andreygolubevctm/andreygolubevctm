package com.ctm.model.home.form;

public class Occupancy {

    private String ownProperty;

    private String principalResidence;

    private WhenMovedIn whenMovedIn;

    private String howOccupied;

    public String getOwnProperty() {
        return ownProperty;
    }

    public void setOwnProperty(String ownProperty) {
        this.ownProperty = ownProperty;
    }

    public String getPrincipalResidence() {
        return principalResidence;
    }

    public void setPrincipalResidence(String principalResidence) {
        this.principalResidence = principalResidence;
    }

    public WhenMovedIn getWhenMovedIn() {
        return whenMovedIn;
    }

    public void setWhenMovedIn(WhenMovedIn whenMovedIn) {
        this.whenMovedIn = whenMovedIn;
    }

    public String getHowOccupied() {
        return howOccupied;
    }

    public void setHowOccupied(String howOccupied) {
        this.howOccupied = howOccupied;
    }
}
