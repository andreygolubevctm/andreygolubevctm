package com.ctm.web.travel.model.results;

/**
 * Java model which will build the travel result sent to the front end.
 * This model is used to hold the data and sort values for the results page.
 * This model is converted to JSON.
 */
public class Offer {

    private final String copy;
    private final String terms;

    public Offer(final String copy, final String terms){
        this.copy = copy;
        this.terms = terms;
    }

    public String getCopy() {
        return copy;
    }

    public String getTerms() {
        return terms;
    }

}
