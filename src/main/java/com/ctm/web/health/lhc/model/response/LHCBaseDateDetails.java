package com.ctm.web.health.lhc.model.response;

import com.ctm.web.core.serializers.LocalDateSerializer;
import com.ctm.web.health.lhc.calculation.LHCDateCalculationSupport;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.time.LocalDate;

public final class LHCBaseDateDetails {
    private final long age;
    @JsonSerialize(using = LocalDateSerializer.class)
    private final LocalDate dateOfBirth;
    @JsonSerialize(using = LocalDateSerializer.class)
    private final LocalDate baseDate;
    private final long lhcDaysApplicable;

    public LHCBaseDateDetails(long age, LocalDate dateOfBirth, LocalDate baseDate, long lhcDaysApplicable) {
        this.age = age;
        this.dateOfBirth = dateOfBirth;
        this.baseDate = baseDate;
        this.lhcDaysApplicable = lhcDaysApplicable;
    }

    public static LHCBaseDateDetails createFrom(LocalDate dateOfBirth) {
        long age = LHCDateCalculationSupport.calculateAgeInYearsFrom(dateOfBirth, LocalDate.now());
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(dateOfBirth);
        Long lhcDaysApplicable = LHCDateCalculationSupport.getLhcDaysApplicable(dateOfBirth, LocalDate.now());
        return new LHCBaseDateDetails(age, dateOfBirth, baseDate, lhcDaysApplicable);
    }

    public long getAge() {
        return age;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public LocalDate getBaseDate() {
        return baseDate;
    }

    public Long getLhcDaysApplicable() {
        return lhcDaysApplicable;
    }
}
