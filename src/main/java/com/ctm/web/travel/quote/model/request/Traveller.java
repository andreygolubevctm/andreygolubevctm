package com.ctm.web.travel.quote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

public class Traveller {

    private TravellerType travellerType;

    @JsonSerialize(contentUsing = LocalDateSerializer.class)
    private LocalDate dateOfBirth;

    public TravellerType getTravellerType() {
        return travellerType;
    }

    public void setTravellerType(TravellerType travellerType) {
        this.travellerType = travellerType;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
}
