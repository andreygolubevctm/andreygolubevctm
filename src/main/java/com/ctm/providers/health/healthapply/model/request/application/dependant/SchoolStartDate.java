package com.ctm.providers.health.healthapply.model.request.application.dependant;

import com.ctm.interfaces.common.types.ValueType;

import java.time.LocalDate;

public class SchoolStartDate extends ValueType<LocalDate> {

    private SchoolStartDate(final LocalDate value) {
        super(value);
    }

    //Used by Jackson to deserialize
    private SchoolStartDate(final String value) {
        super(LocalDate.parse(value));
    }

    public static SchoolStartDate instanceOf(final LocalDate value) {
        return new SchoolStartDate(value);
    }
}