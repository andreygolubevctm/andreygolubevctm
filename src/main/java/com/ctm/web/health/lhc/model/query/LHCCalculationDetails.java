package com.ctm.web.health.lhc.model.query;

import com.ctm.web.health.lhc.model.validation.IfContinuousCoverTrueNeverHadCoverMustBeFalse;

import javax.validation.Valid;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@IfContinuousCoverTrueNeverHadCoverMustBeFalse
public class LHCCalculationDetails {
    @Valid
    private final List<CoverDateRange> coverDates = new ArrayList<>();
    @NotNull
    @Min(0)
    private long age;
    @NotNull
    private LocalDate dateOfBirth;
    @NotNull
    private LocalDate baseDate;
    @NotNull
    @Min(0)
    private long lhcDaysApplicable;
    @NotNull
    private boolean continuousCover;
    @NotNull
    private boolean neverHadCover;

    public long getAge() {
        return age;
    }

    public void setAge(long age) {
        this.age = age;
    }

    public LHCCalculationDetails age(long age) {
        setAge(age);
        return this;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public LHCCalculationDetails dateOfBirth(LocalDate dateOfBirth) {
        setDateOfBirth(dateOfBirth);
        return this;
    }

    public LocalDate getBaseDate() {
        return baseDate;
    }

    public void setBaseDate(LocalDate baseDate) {
        this.baseDate = baseDate;
    }

    public LHCCalculationDetails baseDate(LocalDate localDate) {
        setBaseDate(localDate);
        return this;
    }

    public long getLhcDaysApplicable() {
        return lhcDaysApplicable;
    }

    public void setLhcDaysApplicable(long lhcDaysApplicable) {
        this.lhcDaysApplicable = lhcDaysApplicable;
    }

    public LHCCalculationDetails lhcDaysApplicable(long lhcDaysApplicable) {
        setLhcDaysApplicable(lhcDaysApplicable);
        return this;
    }

    public boolean isContinuousCover() {
        return continuousCover;
    }

    public void setContinuousCover(boolean continuousCover) {
        this.continuousCover = continuousCover;
    }

    public LHCCalculationDetails isContinuousCover(boolean continuousCover) {
        setContinuousCover(continuousCover);
        return this;
    }

    public boolean isNeverHadCover() {
        return neverHadCover;
    }

    public void setNeverHadCover(boolean neverHadCover) {
        this.neverHadCover = neverHadCover;
    }

    public LHCCalculationDetails isNeverHadCover(boolean neverHadCover) {
        setNeverHadCover(neverHadCover);
        return this;
    }

    public List<CoverDateRange> getCoverDates() {
        return coverDates;
    }

    public void setCoverDates(List<CoverDateRange> coverDateRanges) {
        this.coverDates.clear();
        Optional.ofNullable(coverDateRanges).ifPresent(coverDates::addAll);
    }

    public LHCCalculationDetails coverDates(List<CoverDateRange> coverDateRanges) {
        setCoverDates(coverDateRanges);
        return this;
    }

    public LHCCalculationDetails addCoverDateRange(CoverDateRange coverDateRange) {
        this.coverDates.add(coverDateRange);
        return this;
    }
}
