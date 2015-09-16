package com.ctm.providers.health.healthapply.model.request.application.dependant;

import com.ctm.healthapply.model.request.application.common.*;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;
import java.util.Optional;

public class Dependant {

    private Title title;

    private FirstName firstName;

    private LastName lastName;

    private DateOfBirth dateOfBirth;

    private School school;

    @JsonProperty("schoolDate")
    private SchoolStartDate schoolStartDate;

    @JsonProperty("schoolID")
    private SchoolId schoolId;

    private Gender gender;

    public Optional<Title> getTitle() {
        return Optional.ofNullable(title);
    }

    public Optional<FirstName> getFirstName() {
        return Optional.ofNullable(firstName);
    }

    public Optional<LastName> getLastName() {
        return Optional.ofNullable(lastName);
    }

    public Optional<DateOfBirth> getDateOfBirth() {
        return Optional.ofNullable(dateOfBirth);
    }

    public Optional<School> getSchool() {
        return Optional.ofNullable(school);
    }

    public Optional<SchoolStartDate> getSchoolStartDate() {
        return Optional.ofNullable(schoolStartDate);
    }

    public Optional<SchoolId> getSchoolId() {
        return Optional.ofNullable(schoolId);
    }

    public Optional<Gender> getGender() {
        return Optional.ofNullable(gender);
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

    @JsonProperty("school")
    private String outputSchoolSer() {
        return school == null ? null : school.get();
    }

    @JsonProperty("dateOfBirth")
    private LocalDate dateOfBirth() {
        return dateOfBirth == null ? null : dateOfBirth.get();
    }

    @JsonProperty("schoolDate")
    private LocalDate schoolDate() {
        return schoolStartDate == null ? null : schoolStartDate.get();
    }

    @JsonProperty("schoolID")
    private String schoolId() {
        return schoolId == null ? null : schoolId.get();
    }
}
