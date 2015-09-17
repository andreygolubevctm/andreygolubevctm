package com.ctm.providers.health.healthapply.model.request.application.applicant;

import com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover.HealthCover;
import com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund.PreviousFund;
import com.ctm.providers.health.healthapply.model.request.application.common.DateOfBirth;
import com.ctm.providers.health.healthapply.model.request.application.common.FirstName;
import com.ctm.providers.health.healthapply.model.request.application.common.Gender;
import com.ctm.providers.health.healthapply.model.request.application.common.LastName;
import com.ctm.providers.health.healthapply.model.request.application.common.Title;

public class Applicant {

    private final Title title;

    private final FirstName firstName;

    private final LastName lastName;

    private final Gender gender;

    private final DateOfBirth dateOfBirth;

    private final HealthCover healthCover;

    private final PreviousFund previousFund;

    public Applicant(final Title title, final FirstName firstName, final LastName lastName, final Gender gender,
                     final DateOfBirth dateOfBirth, final HealthCover healthCover, final PreviousFund previousFund) {
        this.title = title;
        this.firstName = firstName;
        this.lastName = lastName;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.healthCover = healthCover;
        this.previousFund = previousFund;
    }

}
