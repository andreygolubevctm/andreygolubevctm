package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;

import java.time.LocalDate;
import java.util.List;

import static com.ctm.web.health.lhc.calculation.Constants.*;
import static com.ctm.web.health.lhc.calculation.LHCDateCalculationSupport.hasYearsContiguousCover;

/**
 * {@link NoCoverOnBaseDateCalculator} implements the {@link LHCCalculationStrategy} and defines the algorithm
 * for calculating LHC percentage from an applicant's age and dates of cover when an applicant did not hold cover
 * on the calculated LHC base date.
 */
public class NoCoverOnBaseDateCalculator implements LHCCalculationStrategy {

    private final long applicantAge;
    private final List<CoverDateRange> coverDates;
    private final long lhcDaysApplicable;

    /**
     * Constructs an instance of {@link NoCoverOnBaseDateCalculator} with the specified applicantAge.
     *
     * @param applicantAge the age of the applicant - cannot be less than zero.
     * @param coverDates   a collection of date ranges for which the applicant held valid cover.
     * @throws IllegalArgumentException if applicantAge is less than zero.
     */
    public NoCoverOnBaseDateCalculator(long lhcDaysApplicable, long applicantAge, List<CoverDateRange> coverDates) {
        if (lhcDaysApplicable < 0) {
            throw new IllegalArgumentException("lhcDaysApplicable cannot be less than zero");
        }
        if (applicantAge < 0) {
            throw new IllegalArgumentException("applicant age cannot be less than zero");
        }
        this.lhcDaysApplicable = lhcDaysApplicable;
        this.applicantAge = applicantAge;
        this.coverDates = coverDates;
    }

    @Override
    public int calculateLHCPercentage() {
        long totalDaysOfCover = LHCDateCalculationSupport.getNumberOfDaysCovered(coverDates);
        long lhcApplicableYears = Math.max(0, applicantAge - LHC_REQUIREMENT_AGE);
        long yearsCovered = totalDaysOfCover / 365;
        long applicableDaysWithoutCover = Math.max(0, lhcDaysApplicable - totalDaysOfCover);
        boolean hasExceededUncoveredThreshold = applicableDaysWithoutCover > LHC_DAYS_WITHOUT_COVER_THRESHOLD;
        boolean hasTenYearsContiguousCover = hasYearsContiguousCover(CONTIGUOUS_YEARS_COVER_LHC_RESET_THRESHOLD, coverDates, LocalDate.now());

        final long lhcPercentage;
        if (!hasExceededUncoveredThreshold || hasTenYearsContiguousCover) {
            lhcPercentage = MIN_LHC_PERCENTAGE;
        } else {
            lhcPercentage = (lhcApplicableYears - yearsCovered) * 2;
        }
        return Math.toIntExact(Math.min(lhcPercentage, Constants.MAX_LHC_PERCENTAGE));
    }
}
