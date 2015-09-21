package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

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
}
