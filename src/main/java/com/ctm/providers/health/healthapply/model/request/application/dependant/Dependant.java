package com.ctm.providers.health.healthapply.model.request.application.dependant;

import com.ctm.providers.health.healthapply.model.request.application.common.DateOfBirth;
import com.ctm.providers.health.healthapply.model.request.application.common.FirstName;
import com.ctm.providers.health.healthapply.model.request.application.common.Gender;
import com.ctm.providers.health.healthapply.model.request.application.common.LastName;
import com.ctm.providers.health.healthapply.model.request.application.common.Title;

public class Dependant {

    private Title title;

    private FirstName firstName;

    private LastName lastName;

    private DateOfBirth dateOfBirth;

    private School school;

    private SchoolStartDate schoolDate;

    private SchoolId schoolID;

    private Gender gender;

    public Dependant(final Title title, final FirstName firstName, final LastName lastName,
                     final DateOfBirth dateOfBirth, final School school, final SchoolStartDate schoolDate,
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
