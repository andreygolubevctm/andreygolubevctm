package com.ctm.model.travel.form;


import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by adiente on 05/10/2015.
 */
    public class Travellers {

    private List<String> travellersDOB;

    public String getTraveller1DOB() {
        return travellersDOB != null && !travellersDOB.isEmpty() ? travellersDOB.get(0) : "";
    }

    public void setTraveller1DOB(String traveller1DOB) {
        setTravellersDOB(traveller1DOB);
    }

    public String getTraveller2DOB() {
        return travellersDOB != null && !travellersDOB.isEmpty() ? travellersDOB.get(1) : "";
    }

    public void setTraveller2DOB(String traveller2DOB) {
        setTravellersDOB(traveller2DOB);
    }

    public void setTravellersDOB(String dob) {
        if (travellersDOB == null) {
            travellersDOB = new ArrayList<String>();
        }

        // convert to yyyy-MM-dd format
        DateTimeFormatter dtf = DateTimeFormat.forPattern("dd/MM/yyyy");
        LocalDate dt = dtf.parseLocalDate(dob);
        travellersDOB.add(dt.toString());
    }

    public List<String> getTravellersDOB() {
        return this.travellersDOB;
    }
}
