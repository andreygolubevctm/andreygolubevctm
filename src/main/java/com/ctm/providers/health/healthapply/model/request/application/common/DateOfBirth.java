package com.ctm.providers.health.healthapply.model.request.application.common;

import com.ctm.interfaces.common.types.ValueType;

import java.time.LocalDate;

public class DateOfBirth extends ValueType<LocalDate> {

    private DateOfBirth(final LocalDate value) {
        super(value);
    }

    //Used by Jackson to deserialize
    private DateOfBirth(final String value) {
        super(LocalDate.parse(value));
    }

    public static DateOfBirth instanceOf(final LocalDate value) {
        return new DateOfBirth(value);
    }

}