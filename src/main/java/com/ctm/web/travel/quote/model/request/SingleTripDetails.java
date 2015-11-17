package com.ctm.web.travel.quote.model.request;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Part of the request model for calling CtM's travel-quote application.
 *
 * Data model representing data unique to a single trip
 */
public class SingleTripDetails {

    private List<String> destinations = new ArrayList<>();
    private Date fromDate;
    private Date toDate;

    public SingleTripDetails() {
    }

    public void setDestinations(List<String> destinations) {
        this.destinations = destinations;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public List<String> getDestinations() {
        return destinations;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public Date getToDate() {
        return toDate;
    }
}
