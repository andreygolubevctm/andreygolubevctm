package com.ctm.providers.health.healthapply.model.request.application.dependant;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.ctm.providers.health.healthapply.model.request.application.common.FirstName;
import com.ctm.providers.health.healthapply.model.request.application.common.Gender;
import com.ctm.providers.health.healthapply.model.request.application.common.LastName;
import com.ctm.providers.health.healthapply.model.request.application.common.Title;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Dependant {

    private Title title;

    @JsonSerialize(using = TypeSerializer.class)
    private FirstName firstName;

    @JsonSerialize(using = TypeSerializer.class)
    private LastName lastName;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate dateOfBirth;

    @JsonSerialize(using = TypeSerializer.class)
    private School school;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate schoolDate;

    @JsonSerialize(using = TypeSerializer.class)
    private SchoolId schoolID;

    private Gender gender;

    public Dependant(final Title title, final FirstName firstName, final LastName lastName,
                     final LocalDate dateOfBirth, final School school, final LocalDate schoolDate,
                     final SchoolId schoolID, final Gender gender) {
        this.title = title;
        this.firstName = firstName;
        this.lastName = lastName;
        this.dateOfBirth = dateOfBirth;
        this.school = school;
        this.schoolDate = schoolDate;
        this.schoolID = schoolID;
        this.gender = gender;
    }
}
