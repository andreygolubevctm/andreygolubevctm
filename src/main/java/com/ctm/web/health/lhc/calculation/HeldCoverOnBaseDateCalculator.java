package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;

import java.time.LocalDate;
import java.util.List;

import static com.ctm.web.health.lhc.calculation.Constants.*;
import static com.ctm.web.health.lhc.calculation.LHCDateCalculationSupport.getNumberOfDaysCovered;
import static com.ctm.web.health.lhc.calculation.LHCDateCalculationSupport.hasYearsContiguousCover;

/**
 * {@link HeldCoverOnBaseDateCalculator} implements the {@link LHCCalculationStrategy} and defines the algorithm
 * for calculating LHC percentage when an not always held continuous cover, but held cover on the calculated
 * LHC base date.
 */
public class HeldCoverOnBaseDateCalculator implements LHCCalculationStrategy {

    private final long lhcDaysApplicable;
    private final List<CoverDateRange> coverDates;

    /**
     * Constructs an instance of {@link HeldCoverOnBaseDateCalculator} with the specified number of LHC applicable days
     * and coverage date ranges.
     *
     * @param lhcDaysApplicable the number of days an applicant was required to hold cover to avoid LHC loading.
     * @param coverDates        a collection of date ranges for which the applicant held valid cover.
     */
    HeldCoverOnBaseDateCalculator(long lhcDaysApplicable, List<CoverDateRange> coverDates) {
        if (lhcDaysApplicable < 0) {
            throw new IllegalArgumentException("lhcDaysApplicable cannot be less than zero");
        }
        this.lhcDaysApplicable = lhcDaysApplicable;
        this.coverDates = coverDates;
    }

    @Override
    public int calculateLHCPercentage() {
        int totalDaysOfCover = getNumberOfDaysCovered(coverDates);
        long applicableDaysWithoutCover = Math.max(0, lhcDaysApplicable - totalDaysOfCover);
        boolean hasExceededUncoveredThreshold = applicableDaysWithoutCover > LHC_DAYS_WITHOUT_COVER_THRESHOLD;
        boolean hasTenYearsContiguousCover = hasYearsContiguousCover(CONTIGUOUS_YEARS_COVER_LHC_RESET_THRESHOLD, coverDates, LocalDate.now());

        final long lhcPercentage;

        if (!hasExceededUncoveredThreshold || hasTenYearsContiguousCover) {
            lhcPercentage = MIN_LHC_PERCENTAGE;
        } else {
            long yearsCovered = (applicableDaysWithoutCover - LHC_DAYS_WITHOUT_COVER_THRESHOLD) / 365;
            lhcPercentage = yearsCovered * 2;
        }

        return Long.valueOf(Math.min(lhcPercentage, MAX_LHC_PERCENTAGE)).intValue();
    }
}
