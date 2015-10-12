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

    private List<LocalDate> travellersDOB;
    private final static DateTimeFormatter dtf = DateTimeFormat.forPattern("dd/MM/yyyy");

    public void setTravellersDOB(String dobs) {

        travellersDOB = new ArrayList<LocalDate>();

        String[] parts = dobs.split(",");

        // convert to yyyy-MM-dd format
        Arrays.stream(parts).forEach(age -> {
            travellersDOB.add(dtf.parseLocalDate(age));
        });
    }

    public List<LocalDate> getTravellersDOB() {
        return this.travellersDOB;
    }
}
