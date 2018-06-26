package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.TreeSet;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class PreviouslyHeldCoverCalculationStrategy implements LHCCalculationStrategy {

    private final LocalDate dateOfBirth;
    private final LocalDate baseDate;
    private final List<CoverDateRange> coverDates;
    private final LocalDate now;

    public PreviouslyHeldCoverCalculationStrategy(LocalDate dateOfBirth, LocalDate baseDate, List<CoverDateRange> coverDates, LocalDate now) {
        this.dateOfBirth = dateOfBirth;
        this.baseDate = baseDate;
        this.coverDates = coverDates;
        this.now = now;
    }

    @Override
    public long calculateLHCPercentage() {
        if (coverDates.isEmpty()) {
            return new NeverHeldCoverCalculator(dateOfBirth, now).calculateLHCPercentage();
        }

        Predicate<LocalDate> onlyDaysAfterOrOnBaseDate = date -> date.isAfter(baseDate) || date.isEqual(baseDate);

        LocalDate lastDayOfFirstCover = coverDates.stream()
                .sorted(Comparator.comparing(CoverDateRange::getTo))
                .map(CoverDateRange::getTo)
                .filter(onlyDaysAfterOrOnBaseDate)
                .findFirst()
                .orElse(baseDate);

        LocalDate lhcBeginDate = LHCDateCalculationSupport.getLHCCalculationStartDate(coverDates, dateOfBirth);

        Set<LocalDate> allCoveredDaysAfterBaseDate = LHCDateCalculationSupport.getCoveredDaysInRange(coverDates)
                .stream()
                .filter(onlyDaysAfterOrOnBaseDate)
                .collect(Collectors.toCollection(TreeSet::new));

        GapData gapData = new GapData.Builder()
                .allCoveredDays(allCoveredDaysAfterBaseDate)
                .lastDayOfFirstCover(lastDayOfFirstCover)
                .when(now)
                .createGapData();

        if (LHCDateCalculationSupport.hasYearsContiguousCover(Constants.CONTIGUOUS_YEARS_COVER_LHC_RESET_THRESHOLD, coverDates, now, gapData.getPermittedGapDays())) {
            return Constants.MIN_LHC_PERCENTAGE;
        }

        Set<LocalDate> coveredDaysWithPermittedGaps = Stream.of(allCoveredDaysAfterBaseDate, gapData.getPermittedGapDays())
                .flatMap(Collection::stream)
                .collect(Collectors.toCollection(TreeSet::new));

        Set<LocalDate> allApplicableLHCDays = LHCDateCalculationSupport.getCoveredDaysInRange(Collections.singletonList(new CoverDateRange(lhcBeginDate, now)));

        Optional<LocalDate> lhc10YearResetDate = getResetDate(coveredDaysWithPermittedGaps, gapData);

        Set<LocalDate> daysWithoutCover = getDatesForLHCCalculation(coveredDaysWithPermittedGaps, allApplicableLHCDays, lhc10YearResetDate);

        int lhcPercentage = BigDecimal.valueOf(daysWithoutCover.size()).divide(BigDecimal.valueOf(365), RoundingMode.UP).intValue() * 2;

        return Math.min(lhcPercentage, Constants.MAX_LHC_PERCENTAGE);
    }

    /**
     * Returns a set containing all days for which an applicant is not covered excluding days prior to any LHC Reset
     * date, or permitted gap days.
     *
     * @param coveredOrGapDays                days for which an applicant had cover or were permitted gap days.
     * @param availableDatesForLHCCalculation all days between the {@link LHCDateCalculationSupport#getLHCCalculationStartDate(List, LocalDate)} and the LHC Calculation date.
     * @param lhc10YearResetDate              an Optional LHC Reset Date {@link #getResetDate(Set, GapData)}
     * @return the set of dates for which an applicant was not covered.
     */
    private static Set<LocalDate> getDatesForLHCCalculation(Set<LocalDate> coveredOrGapDays, Set<LocalDate> availableDatesForLHCCalculation, Optional<LocalDate> lhc10YearResetDate) {
        availableDatesForLHCCalculation.removeAll(coveredOrGapDays);
        final Set<LocalDate> daysWithoutCover;
        if (lhc10YearResetDate.isPresent()) {
            LocalDate resetDate = lhc10YearResetDate.get();
            Predicate<LocalDate> onlyDatesAfterResetDate = localDate -> localDate.isAfter(resetDate) || localDate.isEqual(resetDate);
            daysWithoutCover = availableDatesForLHCCalculation.stream()
                    .filter(onlyDatesAfterResetDate)
                    .collect(Collectors.toCollection(TreeSet::new));
        } else {
            daysWithoutCover = availableDatesForLHCCalculation;
        }

        return daysWithoutCover;
    }

    /**
     * Calculate the LHC Reset date if an applicant has exhausted all their gap days and subsequently
     * held 10 years contiguous cover.
     *
     * @param allCoveredDays all covered days including permitted gap days.
     * @param gapData the applicants calculated gap data.
     * @return the most recent date an applicant has held 10 years contiguous cover, otherwise {@link Optional#empty()}
     * @see LHCDateCalculationSupport#getMostRecentLHCResetDate(Set, LocalDate)
     */
    private Optional<LocalDate> getResetDate(Set<LocalDate> allCoveredDays, GapData gapData) {
        final Optional<LocalDate> resetDate;
        if (gapData.hasExhaustedGapDays()) {
            resetDate = LHCDateCalculationSupport.getMostRecentLHCResetDate(allCoveredDays, gapData.getFirstNonPermittedGapDay());
        } else {
            resetDate = Optional.empty();
        }
        return resetDate;
    }

}
