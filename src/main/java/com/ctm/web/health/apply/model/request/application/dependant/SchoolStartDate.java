package com.ctm.web.health.apply.model.request.application.dependant;

import java.time.LocalDate;
import java.util.function.Supplier;

public class SchoolStartDate implements Supplier<LocalDate> {

    private final LocalDate schoolStartDate;

    public SchoolStartDate(final LocalDate schoolStartDate) {
        this.schoolStartDate = schoolStartDate;
    }

    @Override
    public LocalDate get() {
        return schoolStartDate;
    }
}