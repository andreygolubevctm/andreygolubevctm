package com.ctm.web.core.leadService.model;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.StringJoiner;

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

    public String getValues() {
        StringBuilder builder = new StringBuilder();
        builder.append(state);
        builder.append(",");
        builder.append(suburb);
        builder.append(",");
        builder.append(postcode);

        return builder.toString();
    }

    public String getHealthCheckSum(){
        StringJoiner sj = new StringJoiner(",");
        sj.add(state);
        return sj.toString();
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
