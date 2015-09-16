package com.ctm.providers.health.healthapply.model.request.payment.medicare;

import com.ctm.healthapply.model.request.application.applicant.healthCover.Cover;
import com.ctm.healthapply.model.request.application.common.FirstName;
import com.ctm.healthapply.model.request.application.common.LastName;
import com.ctm.healthapply.model.request.payment.common.Expiry;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

import java.util.Optional;

public class Medicare {

    private Cover cover;

    @JsonProperty("number")
    private MedicareNumber medicareNumber;

    private FirstName firstName;

    @JacksonXmlProperty(localName = "surname")
    private LastName lastName;

    private Position position;

    private Expiry expiry;

    public Optional<Cover> getCover() {
        return Optional.ofNullable(cover);
    }

    public Optional<MedicareNumber> getMedicareNumber() {
        return Optional.ofNullable(medicareNumber);
    }

    public Optional<FirstName> getFirstName() {
        return Optional.ofNullable(firstName);
    }

    public Optional<LastName> getLastName() {
        return Optional.ofNullable(lastName);
    }

    public Optional<Position> getPosition() {
        return Optional.ofNullable(position);
    }

    public Optional<Expiry> getExpiry() {
        return Optional.ofNullable(expiry);
    }

    //For making readable output for testing
    @JsonProperty("firstName")
    private String getFirstNameSer() {
        return firstName == null ? null : firstName.get();
    }

    @JsonProperty("lastName")
    private String getLastNameSer() {
        return lastName == null ? null : lastName.get();
    }

    @JsonProperty("position")
    private Integer position() {
        return position == null ? null : position.get();
    }

    @JsonProperty("number")
    private String medicareNumber() {
        return medicareNumber == null ? null : medicareNumber.get();
    }

}
