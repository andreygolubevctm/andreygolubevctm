package com.ctm.web.health.lhc.model.query;

import com.ctm.web.health.lhc.model.validation.ToDateIsEqualOrAfterFromDate;

import javax.validation.constraints.NotNull;
import java.time.LocalDate;

@ToDateIsEqualOrAfterFromDate
public class CoverDateRange {
    @NotNull
    private LocalDate from;
    @NotNull
    private LocalDate to;

    public CoverDateRange(LocalDate from, LocalDate to) {
        this.from = from;
        this.to = to;
    }

    public CoverDateRange() { /* Intentionally empty for Jackson Deserialization. */ }

    public LocalDate getFrom() {
        return from;
    }

    public void setFrom(LocalDate from) {
        this.from = from;
    }

    public CoverDateRange from(LocalDate from) {
        setFrom(from);
        return this;
    }

    public LocalDate getTo() {
        return to;
    }

    public void setTo(LocalDate toDateInclusive) {
        this.to = toDateInclusive;
    }

    public CoverDateRange to(LocalDate toDateInclusive) {
        setTo(toDateInclusive);
        return this;
    }
}
