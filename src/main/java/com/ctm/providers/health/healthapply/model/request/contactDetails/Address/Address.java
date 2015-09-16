package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

import java.util.Optional;

public class Address {

    private Postcode postCode;

    private FullAddressOneLine fullAddressOneLine;

    private Suburb suburb;

    @JacksonXmlProperty(localName = "nonStd")
    private NonStandard nonStandard;

    @JacksonXmlProperty(localName = "streetNum")
    private StreetNumber streetNumber;

    @JacksonXmlProperty(localName = "nonStdStreet")
    private NonStandardStreet nonStandardStreet;

    private DPID dpid;

    private State state;

    public Optional<Postcode> getPostCode() {
        return Optional.ofNullable(postCode);
    }

    public Optional<FullAddressOneLine> getFullAddressOneLine() {
        return Optional.ofNullable(fullAddressOneLine);
    }

    public Optional<Suburb> getSuburb() {
        return Optional.ofNullable(suburb);
    }

    public Optional<NonStandard> getNonStandard() {
        return Optional.ofNullable(nonStandard);
    }

    public Optional<StreetNumber> getStreetNumber() {
        return Optional.ofNullable(streetNumber);
    }

    public Optional<NonStandardStreet> getNonStandardStreet() {
        return Optional.ofNullable(nonStandardStreet);
    }

    public Optional<DPID> getDpid() {
        return Optional.ofNullable(dpid);
    }

    public Optional<State> getState() {
        return Optional.ofNullable(state);
    }

    @JsonProperty("postCode")
    private String postCode() {
        return postCode.get();
    }

    @JsonProperty("fullAddressOneLine")
    private String fullAddressOneLine() {
        return fullAddressOneLine.get();
    }

    @JsonProperty("suburb")
    private String suburb() {
        return suburb.get();
    }

    @JsonProperty("streetNumber")
    private String streetNumber() {
        return streetNumber.get();
    }

    @JsonProperty("nonStandardStreet")
    private String nonStandardStreet() {
        return getNonStandardStreet().orElse(NonStandardStreet.instanceOf("")).get();
    }
}
