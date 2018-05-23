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

    private final List<CoverDateRange> coverDates;
    private final LocalDate baseDate;
    private LocalDate now;

    /**
     * Constructs an instance of {@link NoCoverOnBaseDateCalculator} with the specified applicantAge.
     *
     * @param coverDates a collection of date ranges for which the applicant held valid cover.
     * @param now
     * @throws IllegalArgumentException if applicantAge is less than zero.
     */
    public NoCoverOnBaseDateCalculator(LocalDate baseDate, List<CoverDateRange> coverDates, LocalDate now) {
        this.baseDate = baseDate;
        this.coverDates = coverDates;
        this.now = now;
    }

    @Override
    public long calculateLHCPercentage() {
        final long interimDaysLHCPercentage = getInterimDaysLHCPercentage();
        final long baseDateToCoverStartLHCPercentage = NO_COVER_LHC_BASE_PERCENTAGE + getCoverStartLHCPercentage();

        boolean hasTenYearsContiguousCover = hasYearsContiguousCover(CONTIGUOUS_YEARS_COVER_LHC_RESET_THRESHOLD, coverDates, now);

        if (!hasTenYearsContiguousCover) {
            return Math.min(interimDaysLHCPercentage + baseDateToCoverStartLHCPercentage, Constants.MAX_LHC_PERCENTAGE);
        } else {
            return MIN_LHC_PERCENTAGE;
        }
    }

    private long getCoverStartLHCPercentage() {
        LocalDate minCoverStartDate = LHCDateCalculationSupport.getEarliestStartDate(coverDates).orElse(now);
        long daysBetweenBaseDateAndMinStart = LHCDateCalculationSupport.getDaysBetween(baseDate, minCoverStartDate);
        long yearsBetweenBaseDateAndMinStart = daysBetweenBaseDateAndMinStart / 365;
        return yearsBetweenBaseDateAndMinStart * 2;
    }

    private long getInterimDaysLHCPercentage() {
        LocalDate minCoverEndDate = LHCDateCalculationSupport.getEarliestEndDate(coverDates).orElse(now);

        long lhcInterimDays = LHCDateCalculationSupport.getDaysBetween(minCoverEndDate, now);
        long totalDaysOfCover = LHCDateCalculationSupport.getNumberOfDaysCovered(coverDates);
        long nonCoverDays = Math.max(0, lhcInterimDays - totalDaysOfCover);
        boolean hasExceededUncoveredThreshold = nonCoverDays > LHC_DAYS_WITHOUT_COVER_THRESHOLD;


        final long interimDaysLHCPercentage;
        if (!hasExceededUncoveredThreshold) {
            interimDaysLHCPercentage = MIN_LHC_PERCENTAGE;
        } else {
            long thresholdOffsetYearsWithoutCover = (nonCoverDays - LHC_DAYS_WITHOUT_COVER_THRESHOLD) / 365;
            interimDaysLHCPercentage = thresholdOffsetYearsWithoutCover * 2;
        }
        return interimDaysLHCPercentage;
    }
}
