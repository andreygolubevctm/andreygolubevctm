package com.ctm.energy.quote.request.model;

import javax.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.Optional;

import static java.util.Optional.ofNullable;


public class HouseholdDetails {

    @NotNull
    private  String suburb;

    @NotNull
    private  String postCode;

    @NotNull
    private  boolean movingIn;

    private  LocalDate movingInDate;
    private  String tariff;

    public HouseholdDetails(String suburb, String postCode, boolean movingIn, LocalDate movingInDate, String tariff) {
        this.suburb = suburb;
        this.postCode = postCode;
        this.movingIn = movingIn;
        this.movingInDate = movingInDate;
        this.tariff = tariff;
    }

    @SuppressWarnings("unused")
    private HouseholdDetails(){

    }

    public String getSuburb() {
        return suburb;
    }


    public String getPostCode() {
        return postCode;
    }


    public boolean isMovingIn() {
        return movingIn;
    }


    public Optional<LocalDate> getMovingInDate() {
        return ofNullable(movingInDate);
    }



    public String getTariff() {
        return tariff;
    }

}
