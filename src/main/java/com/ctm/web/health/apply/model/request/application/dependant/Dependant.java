package com.ctm.web.health.apply.model.request.application.dependant;

import com.ctm.web.core.model.request.Gender;
import com.ctm.web.health.apply.helper.TypeSerializer;
import com.ctm.web.health.apply.model.request.application.common.*;
import com.fasterxml.jackson.annotation.JsonFormat;
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
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateOfBirth;

    @JsonSerialize(using = TypeSerializer.class)
    private School school;

    @JsonSerialize(using = TypeSerializer.class)
    private GraduationDate graduationDate;

    @JsonSerialize(using = LocalDateSerializer.class)
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate schoolDate;

    @JsonSerialize(using = TypeSerializer.class)
    private SchoolId schoolID;

    private Gender gender;

    private FullTimeStudent fullTimeStudent;

    private Relationship relationship;

    public Dependant(final Title title, final FirstName firstName, final LastName lastName,
                     final LocalDate dateOfBirth, final School school, final GraduationDate graduationDate,
                     final LocalDate schoolDate, final SchoolId schoolID, final Gender gender,
                     final FullTimeStudent fullTimeStudent, final Relationship relationship) {
        this.title = title;
        this.firstName = firstName;
        this.lastName = lastName;
        this.dateOfBirth = dateOfBirth;
        this.school = school;
        this.graduationDate = graduationDate;
        this.schoolDate = schoolDate;
        this.schoolID = schoolID;
        this.gender = gender;
        this.fullTimeStudent = fullTimeStudent;
        this.relationship = relationship;
    }

    public Title getTitle() {
        return title;
    }

    public FirstName getFirstName() {
        return firstName;
    }

    public LastName getLastName() {
        return lastName;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public School getSchool() {
        return school;
    }

    public GraduationDate getGraduationDate() {
        return graduationDate;
    }

    public LocalDate getSchoolDate() {
        return schoolDate;
    }

    public SchoolId getSchoolID() {
        return schoolID;
    }

    public Gender getGender() {
        return gender;
    }

    public FullTimeStudent getFullTimeStudent() {
        return fullTimeStudent;
    }

    public Relationship getRelationship() {
        return relationship;
    }
}
