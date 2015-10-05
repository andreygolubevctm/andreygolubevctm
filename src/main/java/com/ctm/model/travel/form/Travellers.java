package com.ctm.model.travel.form;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by adiente on 05/10/2015.
 */
public class Travellers {

    private List<String> travellersDOBs;

    public String getTraveller1DOB() {
        return travellersDOBs != null && !travellersDOBs.isEmpty() ? travellersDOBs.get(0) : "";
    }

    public void setTraveller1DOB(String traveller1DOB) {
        setTravellersDOB(traveller1DOB);
    }

    public String getTraveller2DOB() {
        return travellersDOBs != null && !travellersDOBs.isEmpty() ? travellersDOBs.get(1) : "";
    }

    public void setTraveller2DOB(String traveller2DOB) {
        setTravellersDOB(traveller2DOB);
    }

    public void setTravellersDOB(String dob) {
        if (travellersDOBs == null) {
            travellersDOBs = new ArrayList<String>();
        }

        travellersDOBs.add(dob);
    }

    public List<String> getTravellersDOBs() {
        return this.travellersDOBs;
    }
}
