package com.ctm.providers.home.homequote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

public class PolicyHolder {

    private String title;

    private String firstName;

    private String surname;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate dateOfBirth;

    private Boolean retried;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Boolean isRetried() {
        return retried;
    }

    public void setRetried(Boolean retried) {
        this.retried = retried;
    }
}
