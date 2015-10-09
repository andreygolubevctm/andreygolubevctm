package com.ctm.providers.car.carquote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

public class RegularDriver {

    private String firstName;

    private String surname;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate dateOfBirth;

    private String hasClaims;

    private GenderType gender;

    private String employmentStatus;

    private Integer licenceAge;

    private Integer noClaimsDiscount;

    private boolean ownsAnotherCar;

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

    public String getHasClaims() {
        return hasClaims;
    }

    public void setHasClaims(String hasClaims) {
        this.hasClaims = hasClaims;
    }

    public GenderType getGender() {
        return gender;
    }

    public void setGender(GenderType gender) {
        this.gender = gender;
    }

    public String getEmploymentStatus() {
        return employmentStatus;
    }

    public void setEmploymentStatus(String employmentStatus) {
        this.employmentStatus = employmentStatus;
    }

    public Integer getLicenceAge() {
        return licenceAge;
    }

    public void setLicenceAge(Integer licenceAge) {
        this.licenceAge = licenceAge;
    }

    public Integer getNoClaimsDiscount() {
        return noClaimsDiscount;
    }

    public void setNoClaimsDiscount(Integer noClaimsDiscount) {
        this.noClaimsDiscount = noClaimsDiscount;
    }

    public boolean isOwnsAnotherCar() {
        return ownsAnotherCar;
    }

    public void setOwnsAnotherCar(boolean ownsAnotherCar) {
        this.ownsAnotherCar = ownsAnotherCar;
    }
}
