package com.ctm.providers.health.healthapply.model.request.application.common;

import java.time.LocalDate;

public class DateOfBirth {

    private final LocalDate dateOfBirth;

    public DateOfBirth(final LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
}