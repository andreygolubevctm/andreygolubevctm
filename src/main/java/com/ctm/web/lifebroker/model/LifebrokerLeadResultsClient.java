package com.ctm.web.lifebroker.model;

public class LifebrokerLeadResultsClient {

    private String reference;

    public void setReference(String reference) {
        this.reference = reference;
    }

    public LifebrokerLeadResultsClient withReference(String reference) {
        this.reference = reference;
        return this;
    }

    public String getReference() {
        return reference;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LifebrokerLeadResultsClient that = (LifebrokerLeadResultsClient) o;
        return reference != null ? reference.equals(that.reference) : that.reference == null;
    }

    @Override
    public int hashCode() {
        return reference != null ? reference.hashCode() : 0;
    }
}
