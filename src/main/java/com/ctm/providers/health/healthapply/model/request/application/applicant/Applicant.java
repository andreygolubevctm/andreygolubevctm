package com.ctm.providers.health.healthapply.model.request.application.applicant;

import com.ctm.healthapply.model.request.application.applicant.healthCover.HealthCover;
import com.ctm.healthapply.model.request.application.applicant.previousFund.PreviousFund;
import com.ctm.healthapply.model.request.application.common.*;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;
import java.util.Optional;

public class Applicant {

    private Title title;

    private FirstName firstName;

    private LastName lastName;

    private Gender gender;

    private DateOfBirth dateOfBirth;

    private HealthCover healthCover;

    private PreviousFund previousFund;

    public Optional<Title> getTitle() {
        return Optional.ofNullable(title);
    }

    public Optional<FirstName> getFirstName() {
        return Optional.ofNullable(firstName);
    }

    public Optional<LastName> getLastName() {
        return Optional.ofNullable(lastName);
    }

    public Optional<Gender> getGender() {
        return Optional.ofNullable(gender);
    }

    public Optional<DateOfBirth> getDateOfBirth() {
        return Optional.ofNullable(dateOfBirth);
    }

    public Optional<HealthCover> getHealthCover() {
        return Optional.ofNullable(healthCover);
    }

    public Optional<PreviousFund> getPreviousFund() {
        return Optional.ofNullable(previousFund);
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

    @JsonProperty("dateOfBirth")
    private LocalDate dateOfBirth() {
        return dateOfBirth == null ? null : dateOfBirth.get();
    }
}
