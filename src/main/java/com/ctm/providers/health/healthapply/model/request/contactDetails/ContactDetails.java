package com.ctm.providers.health.healthapply.model.request.contactDetails;

import com.ctm.healthapply.model.request.contactDetails.Address.Address;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Optional;

public class ContactDetails {

    private Email email;

    private OptInEmail optInEmail;

    private MobileNumber mobileNumber;

    private OtherNumber otherNumber;

    private Call call;

    private PostalMatch postalMatch;

    @JsonProperty("address")
    private Address streetAddress;

    @JsonProperty("postal")
    private Address postalAddress;

    public Optional<Email> getEmail() {
        return Optional.ofNullable(email);
    }

    public Optional<OptInEmail> getOptInEmail() {
        return Optional.ofNullable(optInEmail);
    }

    public Optional<MobileNumber> getMobileNumber() {
        return Optional.ofNullable(mobileNumber);
    }

    public Optional<OtherNumber> getOtherNumber() {
        return Optional.ofNullable(otherNumber);
    }

    public Optional<Call> getCall() {
        return Optional.ofNullable(call);
    }


    public Optional<PostalMatch> getPostalMatch() {
        return Optional.ofNullable(postalMatch);
    }

    public Optional<Address> getStreetAddress() {
        return Optional.ofNullable(streetAddress);
    }

    public Optional<Address> getPostalAddress() {
        return Optional.ofNullable(postalAddress);
    }

    //Jackson serialization methods
    @JsonProperty("email")
    private String outputEmail() {
        return email.get();
    }

    @JsonProperty("mobileNumber")
    private String mobileNumber() {
        return mobileNumber.get();
    }

    @JsonProperty("otherNumber")
    private String otherNumber() {
        return otherNumber.get();
    }
}
