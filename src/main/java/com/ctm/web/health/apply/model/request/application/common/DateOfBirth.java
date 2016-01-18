package com.ctm.web.health.apply.model.request.application.common;

import java.time.LocalDate;
import java.util.function.Supplier;

public class DateOfBirth implements Supplier<LocalDate> {

    private final LocalDate dateOfBirth;

    public DateOfBirth(final LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    @Override
    public LocalDate get() {
        return dateOfBirth;
    }
}