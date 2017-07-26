package com.ctm.web.travel.model.form;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Created by adiente on 05/10/2015.
 */
public class Travellers {

    private List<Integer> travellersAge;

    public Travellers() {

    }

    private Travellers(List<Integer> travellersAge) {
        this.travellersAge = Collections.unmodifiableList(travellersAge);
    }

    public static Travellers of(final List<Integer> ages) {
        return new Travellers(ages);
    }

    public List<Integer> getTravellersAge() {
        return travellersAge;
    }

    public void setTravellersAge(String ages) {
        travellersAge = new ArrayList<>();
        String[] agesArr = ages.split(",");
        Arrays.stream(agesArr).forEach(age -> {
            travellersAge.add(Integer.valueOf(age));
        });
    }
}
