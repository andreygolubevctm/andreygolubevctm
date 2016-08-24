package com.ctm.web.health.apply.model.request.contactDetails.Address;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Address {

    @JsonSerialize(using = TypeSerializer.class)
    private Postcode postCode;

    @JsonSerialize(using = TypeSerializer.class)
    private FullAddressOneLine fullAddressOneLine;

    @JsonSerialize(using = TypeSerializer.class)
    private Suburb suburb;

    @JsonSerialize(using = TypeSerializer.class)
    private StreetNumber streetNum;

    @JsonSerialize(using = TypeSerializer.class)
    private DPID dpid;

    private State state;

    public Address(final Postcode postCode, final FullAddressOneLine fullAddressOneLine, final Suburb suburb,
                   final StreetNumber streetNum, final DPID dpid, final State state) {
        this.postCode = postCode;
        this.fullAddressOneLine = fullAddressOneLine;
        this.suburb = suburb;
        this.streetNum = streetNum;
        this.dpid = dpid;
        this.state = state;
    }

    public Postcode getPostCode() {
        return postCode;
    }

    public FullAddressOneLine getFullAddressOneLine() {
        return fullAddressOneLine;
    }

    public Suburb getSuburb() {
        return suburb;
    }

    public StreetNumber getStreetNum() {
        return streetNum;
    }

    public DPID getDpid() {
        return dpid;
    }

    public State getState() {
        return state;
    }
}
