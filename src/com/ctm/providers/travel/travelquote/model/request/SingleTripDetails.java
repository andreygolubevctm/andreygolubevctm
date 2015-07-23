package com.ctm.providers.travel.travelquote.model.request;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
