package com.ctm.model.travel.form;


import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by adiente on 05/10/2015.
 */
    public class Travellers {

    private List<String> travellersDOB;

    public void setTravellersDOB(String dobs) {
        if (travellersDOB == null) {
            travellersDOB = new ArrayList<String>();
        }

        String[] parts = dobs.split(",");

        // convert to yyyy-MM-dd format
        Arrays.stream(parts).forEach(age -> {
            DateTimeFormatter dtf = DateTimeFormat.forPattern("dd/MM/yyyy");
            LocalDate dt = dtf.parseLocalDate(age);
            travellersDOB.add(dt.toString());
        });
    }

    public List<String> getTravellersDOB() {
        return this.travellersDOB;
    }
}
