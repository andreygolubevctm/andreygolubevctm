package com.ctm.providers.health.healthapply.model.request.application.applicant;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover.HealthCover;
import com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund.PreviousFund;
import com.ctm.providers.health.healthapply.model.request.application.common.*;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

public class Applicant {

    private final Title title;

    @JsonSerialize(using = TypeSerializer.class)
    private final FirstName firstName;

    @JsonSerialize(using = TypeSerializer.class)
    private final LastName lastName;

    private final Gender gender;

    @JsonSerialize(using = LocalDateSerializer.class)
    private final LocalDate dateOfBirth;

    private final HealthCover healthCover;

    private final PreviousFund previousFund;

    public Applicant(final Title title, final FirstName firstName, final LastName lastName, final Gender gender,
                     final LocalDate dateOfBirth, final HealthCover healthCover, final PreviousFund previousFund) {
        this.title = title;
        this.firstName = firstName;
        this.lastName = lastName;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.healthCover = healthCover;
        this.previousFund = previousFund;
    }

}
