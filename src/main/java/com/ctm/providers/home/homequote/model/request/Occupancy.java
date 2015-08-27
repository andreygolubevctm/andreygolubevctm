package com.ctm.providers.home.homequote.model.request;

public class Occupancy {

    private boolean ownProperty;

    private boolean principalResidence;

    private WhenMovedIn whenMovedIn;

    private String howOccupied;

    public boolean isOwnProperty() {
        return ownProperty;
    }

    public void setOwnProperty(boolean ownProperty) {
        this.ownProperty = ownProperty;
    }

    public boolean isPrincipalResidence() {
        return principalResidence;
    }

    public void setPrincipalResidence(boolean principalResidence) {
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
