package com.ctm.web.core.model;

import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

public class CompetitionEntry {

    @NotNull
    private Integer competitionId;

    @NotNull
    @NotEmpty
    private String source;

    @NotNull
    @NotEmpty(message = "Your first name is required.")
    private String firstName;

    private String lastName;

    @NotNull
    @NotEmpty(message = "Your email address is required.")
    private String email;

    private String phoneNumber;

    private boolean phoneNumberRequired;

    public Integer getCompetitionId() {
        return competitionId;
    }

    public void setCompetitionId(Integer competitionId) {
        this.competitionId = competitionId;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public boolean isPhoneNumberRequired() {
        return phoneNumberRequired;
    }

    public void setPhoneNumberRequired(boolean phoneNumberRequired) {
        this.phoneNumberRequired = phoneNumberRequired;
    }
}
