package com.ctm.providers.car.carquote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.joda.ser.LocalDateSerializer;
import org.joda.time.LocalDate;

public class YoungestDriver {

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate dateOfBirth;

    private GenderType gender;

    private Integer licenceAge;

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public GenderType getGender() {
        return gender;
    }

    public void setGender(GenderType gender) {
        this.gender = gender;
    }

    public Integer getLicenceAge() {
        return licenceAge;
    }

    public void setLicenceAge(Integer licenceAge) {
        this.licenceAge = licenceAge;
    }
}