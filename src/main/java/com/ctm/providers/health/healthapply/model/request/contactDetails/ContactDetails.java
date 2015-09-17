package com.ctm.providers.health.healthapply.model.request.contactDetails;


import com.ctm.providers.health.healthapply.model.request.contactDetails.Address.Address;

public class ContactDetails {

    private Email email;

    private OptInEmail optInEmail;

    private MobileNumber mobileNumber;

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
