package com.ctm.web.travel.model.form;




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

    //private List<LocalDate> travellersDOB;

    private List<Integer> travellersAge;

    //private final static DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public Travellers() {

    }

    private Travellers(List<Integer> travellersAge){
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
        Arrays.stream(agesArr).forEach(age->{
            travellersAge.add(Integer.valueOf(age));
        });
        //this.travellersAge = travellersAge;
    }

    /* private Travellers(List<LocalDate> travellersDOB) {
        this.travellersDOB = Collections.unmodifiableList(travellersDOB);
    }*/

    /*public static Travellers of(final List<LocalDate> Dobs) {
        return new Travellers(Dobs);
    }*/

   /* public void setTravellersDOB(String dobs) {

        travellersDOB = new ArrayList<>();


        String[] parts = dobs.split(",");

        // convert to yyyy-MM-dd format
        Arrays.stream(parts).forEach(age -> {
            travellersDOB.add(LocalDate.parse(age,dtf));
        });
    }

    public List<LocalDate> getTravellersDOB() {
        return this.travellersDOB;
    }*/
}
