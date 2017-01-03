package com.ctm.web.travel.quote.model.response;

public class Offer {

    public final String description;

    public final String terms;

    // empty constructor needed by jackson
    @SuppressWarnings("UnusedDeclaration")
    public Offer() {
        this.description = "";
        this.terms = "";
    }


    @Override
    @SuppressWarnings("RedundantIfStatement")
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final Offer offer = (Offer) o;

        if (description != null ? !description.equals(offer.description) : offer.description != null) return false;
        if (terms != null ? !terms.equals(offer.terms) : offer.terms != null) return false;

        return true;
    }

    @Override
    public String toString() {
        return "Offer{" +
                "description='" + description + '\'' +
                ", terms='" + terms + '\'' +
                '}';
    }

    public String getDescription() {
        return description;
    }

    public String getTerms() {
        return terms;
    }

}
