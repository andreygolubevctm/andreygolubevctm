package com.ctm.providers.travel.travelquote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Part of the request model for calling CtM's travel-quote application.
 *
 * Data model representing data unique to a single trip
 */
public class SingleTripDetails {

    private List<String> destinations = new ArrayList<>();

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate fromDate;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate toDate;

    public SingleTripDetails() {
    }

    public void setDestinations(List<String> destinations) {
        this.destinations = destinations;
    }

    public void setFromDate(LocalDate fromDate) {
        this.fromDate = fromDate;
    }

    public void setToDate(LocalDate toDate) {
        this.toDate = toDate;
    }

    public List<String> getDestinations() {
        return destinations;
    }

    public LocalDate getFromDate() {
        return fromDate;
    }

    public LocalDate getToDate() {
        return toDate;
    }
}
