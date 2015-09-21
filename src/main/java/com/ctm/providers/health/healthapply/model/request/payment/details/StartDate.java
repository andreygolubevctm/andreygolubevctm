package com.ctm.providers.health.healthapply.model.request.payment.details;

import java.time.LocalDate;
import java.util.function.Supplier;

public class StartDate implements Supplier<LocalDate> {

    private final LocalDate startDate;

    public StartDate(final LocalDate startDate) {
        this.startDate = startDate;
    }

    @Override
    public LocalDate get() {
        return startDate;
    }
}