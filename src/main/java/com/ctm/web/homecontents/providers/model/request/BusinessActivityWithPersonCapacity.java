package com.ctm.web.homecontents.providers.model.request;

public class BusinessActivityWithPersonCapacity extends BusinessActivity {

    private int numberOfOccupants;

    private boolean registered;

    public int getNumberOfOccupants() {
        return numberOfOccupants;
    }

    public void setNumberOfOccupants(int numberOfOccupants) {
        this.numberOfOccupants = numberOfOccupants;
    }

    public boolean isRegistered() {
        return registered;
    }

    public void setRegistered(boolean registered) {
        this.registered = registered;
    }
}
