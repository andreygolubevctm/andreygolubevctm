package com.ctm.web.travel.model.results;

/**
 * Java model which will build the travel result sent to the front end.
 * This model is used to hold the data and sort values for the results page.
 * This model is converted to JSON.
 */
public class Offer {

    private String copy;
    private String terms;

    public Offer(){
        this.copy = "";
        this.terms = "";
    }

    public String getCopy() {
        return copy;
    }

    public void setCopy(String copy) {
        this.copy = copy;
    }

    public String getTerms() {
        return terms;
    }

    public void setTerms(String terms) {
        this.terms = terms;
    }
}
