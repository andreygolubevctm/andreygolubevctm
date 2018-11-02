package com.ctm.web.core.leadService.model;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Address {
    private String state;
    private String suburb;
    private String postcode;

    public void setState(String state) {
        this.state = state;
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getState() {
        return state;
    }

    public String getSuburb() {
        return suburb;
    }

    public String getPostcode() {
        return postcode;
    }

    @Override
    public String toString() {
        return "Address{" +
                "state=" + state +
                ", suburb=" + suburb +
                ", postcode=" + postcode +
                '}';
    }
}
