package com.ctm.providers.health.healthapply.model.request.contactDetails;


import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.ctm.providers.health.healthapply.model.request.contactDetails.Address.Address;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class ContactDetails {

    @JsonSerialize(using = TypeSerializer.class)
    private Email email;

    private OptInEmail optInEmail;

    @JsonSerialize(using = TypeSerializer.class)
    private MobileNumber mobileNumber;

    @JsonSerialize(using = TypeSerializer.class)
    private OtherNumber otherNumber;

    private Call call;

    private PostalMatch postalMatch;

    private Address address;

    private Address postal;

    public ContactDetails(final Email email, final OptInEmail optInEmail, final MobileNumber mobileNumber,
                          final OtherNumber otherNumber, final Call call, final PostalMatch postalMatch,
                          final Address address, final Address postal) {
        this.email = email;
        this.optInEmail = optInEmail;
        this.mobileNumber = mobileNumber;
        this.otherNumber = otherNumber;
        this.call = call;
        this.postalMatch = postalMatch;
        this.address = address;
        this.postal = postal;
    }
}
