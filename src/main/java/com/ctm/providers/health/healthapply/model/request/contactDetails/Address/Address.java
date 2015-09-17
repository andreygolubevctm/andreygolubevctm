package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

public class Address {

    private Postcode postCode;

    private FullAddressOneLine fullAddressOneLine;

    private Suburb suburb;

    private StreetNumber streetNum;

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
