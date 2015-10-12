package com.ctm.model.travel.form;


import org.joda.time.format.DateTimeFormat;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Created by adiente on 05/10/2015.
 */
    public class Travellers {

    private List<LocalDate> travellersDOB;
    private final static DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public Travellers() {

    }

    private Travellers(List<LocalDate> travellersDOB) {
        this.travellersDOB = Collections.unmodifiableList(travellersDOB);
    }

    public static Travellers of(final List<LocalDate> Dobs) {
        return new Travellers(Dobs);
    }

    public void setTravellersDOB(String dobs) {

        travellersDOB = new ArrayList<>();


        String[] parts = dobs.split(",");

        // convert to yyyy-MM-dd format
        Arrays.stream(parts).forEach(age -> {
            travellersDOB.add(LocalDate.parse(age,dtf));
        });
    }

    public List<LocalDate> getTravellersDOB() {
        return this.travellersDOB;
    }
}
