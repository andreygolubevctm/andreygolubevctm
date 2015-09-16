package com.ctm.providers.health.healthapply.model.request.payment.details;

import com.ctm.interfaces.common.types.ValueType;

import java.time.LocalDate;

public class StartDate extends ValueType<LocalDate> {

    //Used by Jackson to deserialize
    private StartDate(final String value) {
        super(LocalDate.parse(value));
    }

    private StartDate(final LocalDate value) {
        super(value);
    }

    public static StartDate instanceOf(final LocalDate value) {
        return new StartDate(value);
    }

    public static StartDate instanceOf(final String value) {
        return new StartDate(LocalDate.parse(value));
    }

}