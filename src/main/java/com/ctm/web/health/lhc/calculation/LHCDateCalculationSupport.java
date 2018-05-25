package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import org.elasticsearch.common.collect.ImmutableList;

import java.time.LocalDate;
import java.time.chrono.ChronoLocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.TreeSet;
import java.util.function.BiFunction;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

/**
 * Utility class containing methods to assist in calculating LHC Percentage and coverage dates.
 */
public class LHCDateCalculationSupport {

    /**
     * Function to determine whether an instance is between or equal to the from and to dates of an instance of
     * {@link CoverDateRange}.
     * <p>
     * i.e. Given a date range of:
     * <pre>
     *  {
     *      "from": "2016-05-10",
     *      "to": "2017-05-10"
     *  }
     * </pre>
     * The following dates will evaluate to {@code true}
     * <ul>
     * <li>{@code 2016-05-10} - equal to {@link CoverDateRange#getFrom()}</li>
     * <li>{@code 2017-05-10} - equal to {@link CoverDateRange#getTo()}</li>
     * <li>{@code 2016-12-31} - between {@link CoverDateRange#getFrom()} and {@link CoverDateRange#getTo()}</li>
     * </ul>
     * <p>
     * However, the following dates will evaluate to {@code false}:
     * <ul>
     * <li>{@code 2016-05-9} - before {@link CoverDateRange#getFrom()}</li>
     * <li>{@code 2017-05-11} - after {@link CoverDateRange#getTo()}</li>
     * </ul>
     *
     * @see LocalDate#isBefore(ChronoLocalDate)
     * @see LocalDate#isAfter(ChronoLocalDate)
     */
    public static final BiFunction<LocalDate, CoverDateRange, Boolean> isInRange = (localDate, coverDateRange) -> {
        LocalDate fromDateExclusive = coverDateRange.getFrom().minusDays(1);
        LocalDate toDateExclusive = coverDateRange.getTo().plusDays(1);
        return localDate.isBefore(toDateExclusive) && localDate.isAfter(fromDateExclusive);
    };

    /**
     * Generate a stream of days occurring between two instances of LocalDate (inclusive).
     * <p>
     * The {@code startDate} and {@code endDate} are included in the stream
     * (and will therefore occur at the first and last positions of the stream).
     */
    public static BiFunction<LocalDate, LocalDate, Stream<LocalDate>> daysInclusive = (startInclusive, endInclusive) -> {
        LocalDate rangeEndExclusive = endInclusive.plusDays(1);
        long numOfDaysBetween = Math.max(0, ChronoUnit.DAYS.between(startInclusive, rangeEndExclusive));
        return IntStream.iterate(0, i -> i + 1)
                .limit(numOfDaysBetween)
                .mapToObj(startInclusive::plusDays);
    };

    public static long getDaysBetween(LocalDate startInclusive, LocalDate endInclusive)  {
        return getCoveredDaysInRange(ImmutableList.of(new CoverDateRange(startInclusive, endInclusive))).size();
    }

     /**
     * Calculate the number of years from {@code dateOfBirth} until {@code untilDay}.
     * If a the {@code dateOfBirth} is not before {@code untilDay}, zero will be returned.
     *
     * @param dateOfBirth
     * @return the number of years from {@code dateOfBirth} until {@code untilDay}.
     */
    public static long calculateAgeInYearsFrom(LocalDate dateOfBirth, LocalDate untilDay) {
        if (!dateOfBirth.isBefore(untilDay)) {
            return 0;
        }
        return ChronoUnit.YEARS.between(dateOfBirth, untilDay);
    }

    /**
     * Utility function to calculate a person's age on 1st July 2000.
     * If the {@code dateOfBirth} is after 1st July 2000, zero will be returned.
     *
     * @param dateOfBirth the date of birth.
     * @return the number of years of age a person would be on 1st July 2000.
     */
    public static long calculateAgeInYearsAtJulyFirst2000(LocalDate dateOfBirth) {
        return calculateAgeInYearsFrom(dateOfBirth, Constants.JULY_FIRST_2000);
    }

    public static LocalDate getBaseDate(LocalDate dateOfBirth) {
        long ageInYearsAtJulyFirst2000 = calculateAgeInYearsAtJulyFirst2000(dateOfBirth);
        if (ageInYearsAtJulyFirst2000 < Constants.LHC_EXEMPT_AGE_CUT_OFF) {
            return Constants.JULY_FIRST_2000.plusYears(Constants.LHC_EXEMPT_AGE_CUT_OFF - ageInYearsAtJulyFirst2000);
        } else {
            return Constants.JULY_FIRST_2000;
        }
    }

    /**
     * Return the unique number of LHC applicable days between a date of birth and the specified date
     * <p>
     * On the specified {@code onDay}, if a person born on {@code dateOfBirth}, calculate the number of days between
     * those two dates;
     * <p>
     * Unless the date of birth is before 01/07/1934, or the person is aged less than 31, in which case the days
     * applicable is ZERO.
     *
     * @param dateOfBirth the date of birth
     * @param onDay       the specified day for calculation.
     * @return the number of LHC applicable days.
     */
    public static long getLhcDaysApplicable(LocalDate dateOfBirth, LocalDate onDay) {
        if (calculateAgeInYearsFrom(dateOfBirth, onDay) < Constants.LHC_EXEMPT_AGE_CUT_OFF
                || dateOfBirth.isBefore(Constants.LHC_BIRTHDAY_APPLICABILITY_DATE)) {
            return 0;
        }
        LocalDate baseDate = getBaseDate(dateOfBirth);
        Set<LocalDate> lhcDaysApplicable = getCoveredDaysInRange(ImmutableList.of(new CoverDateRange(baseDate, onDay)));
        return lhcDaysApplicable.size();
    }

    /**
     * Return whether the given {@code baseDate} is contained within at least one of the instances of
     * {@link CoverDateRange} contained in the {@code coverDates} collection.
     *
     * @param baseDate   the base date to check.
     * @param coverDates the collection of {@link CoverDateRange} instances.
     * @return true if the given {@code baseDate} is contained within at least one of the instances of
     * {@link CoverDateRange}, otherwise false.
     */
    public static boolean heldCoverOnBaseDate(LocalDate baseDate, List<CoverDateRange> coverDates) {
        return coverDates.stream().anyMatch(dateRange -> isInRange.apply(baseDate, dateRange));
    }

    /**
     * Calculates the number of unique days included in a collection of {@link CoverDateRange} instances. Overlapping dates
     * between {@link CoverDateRange} instances will be ignored.
     *
     * @param coverDateRanges the collection of {@link CoverDateRange} instances.
     * @return the number of unique days included in a collection of {@link CoverDateRange} instances.
     */
    public static int getNumberOfDaysCovered(List<CoverDateRange> coverDateRanges) {
        Set<LocalDate> uniqueDatesInRange = getCoveredDaysInRange(coverDateRanges);
        return uniqueDatesInRange.size();
    }

    /**
     * Return a set of unique days included in a collection of {@link CoverDateRange} instances. Overlapping dates
     * between {@link CoverDateRange} instances will be ignored.
     *
     * @param coverDateRanges the collection of {@link CoverDateRange} instances.
     * @return a set of unique days included in a collection of {@link CoverDateRange} instances.
     */
    public static Set<LocalDate> getCoveredDaysInRange(List<CoverDateRange> coverDateRanges) {
        return Optional.ofNullable(coverDateRanges).orElse(Collections.emptyList())
                .stream()
                .flatMap(r -> daysInclusive.apply(r.getFrom(), r.getTo()))
                .collect(Collectors.toCollection(TreeSet::new));
    }

    /**
     * Returns the earliest {@link CoverDateRange#getFrom()} date from a collection of {@link CoverDateRange} instances.
     *
     * @param coverDateRanges the collection of {@link CoverDateRange} instances.
     * @return the earliest {@link CoverDateRange#getFrom()} date from a collection of {@link CoverDateRange} instances.
     */
    public static Optional<LocalDate> getFirstDayInRange(List<CoverDateRange> coverDateRanges) {
        return getCoveredDaysInRange(coverDateRanges).stream().limit(1).findFirst();
    }

    /**
     * Returns the max {@link CoverDateRange#getTo()} date from a collection of {@link CoverDateRange} instances.
     *
     * @param coverDateRanges the collection of {@link CoverDateRange} instances.
     * @return the max {@link CoverDateRange#getTo()} date from a collection of {@link CoverDateRange} instances.
     */
    public static Optional<LocalDate> getLastDayInRange(List<CoverDateRange> coverDateRanges) {
        Set<LocalDate> daysInRange = getCoveredDaysInRange(coverDateRanges);
        int n = Math.max(0, daysInRange.size() - 1);
        return daysInRange.stream().skip(n).findFirst();
    }

    /**
     * Calculates if a collection of {@link CoverDateRange} instances are contiguous.
     *
     * @param coverDateRanges the collection of {@link CoverDateRange}.
     * @return true if a collection of {@link CoverDateRange} instances is contiguous.
     */
    public static boolean isContiguous(List<CoverDateRange> coverDateRanges) {
        Set<LocalDate> contiguousDatesInRange = getContiguousDateRange(coverDateRanges)
                .map(ImmutableList::of)
                .map(LHCDateCalculationSupport::getCoveredDaysInRange)
                .orElse(Collections.emptySet());
        Set<LocalDate> coveredDaysInRange = getCoveredDaysInRange(coverDateRanges);
        return contiguousDatesInRange.equals(coveredDaysInRange);
    }

    /**
     * Calculate a {@link CoverDateRange} using the earliest {@link CoverDateRange#getFrom()} and maximum
     * {@link CoverDateRange#getTo()} regardless of contiguity.
     *
     * @param coverDateRanges the collection of {@link CoverDateRange}.
     * @return a {@link CoverDateRange} encapsulating all dates within the collection of {@code coverDateRanges}.
     */
    public static Optional<CoverDateRange> getContiguousDateRange(List<CoverDateRange> coverDateRanges) {
        Optional<LocalDate> firstDay = getFirstDayInRange(coverDateRanges);
        Optional<LocalDate> lastDay = getLastDayInRange(coverDateRanges);
        final Optional<CoverDateRange> range;
        if (firstDay.isPresent() && lastDay.isPresent()) {
            LocalDate rangeStart = firstDay.get();
            LocalDate rangeEndInclusive = lastDay.get();
            range = Optional.of(new CoverDateRange(rangeStart, rangeEndInclusive));

        } else {
            range = Optional.empty();
        }
        return range;
    }

    /**
     * Given a collection of {@link CoverDateRange}, calculate whether the entire coverage date range is contiguous from
     * the coverage end date for at least the given number of years.
     *
     * @param numberOfYears   the number of years from the coverage end date (inclusive)
     * @param coverDateRanges the range of dates to check for contiguous cover.
     * @param toDate          the end date for the coverage range.
     * @return true if the date range contains contiguous cover from the maximum cover date minus {@code numberOfYears}.
     */
    public static boolean hasYearsContiguousCover(int numberOfYears, List<CoverDateRange> coverDateRanges, LocalDate toDate) {
        LocalDate nYearsAgo = toDate.minusYears(numberOfYears);
        CoverDateRange contiguousCoverDateRange = new CoverDateRange(nYearsAgo, toDate);
        Set<LocalDate> contiguousDatesInRangeForLastNYears = getCoveredDaysInRange(ImmutableList.of(contiguousCoverDateRange));
        Set<LocalDate> coveredDaysInLastNYears = getCoveredDaysInRange(coverDateRanges).stream()
                .filter(l -> isInRange.apply(l, contiguousCoverDateRange))
                .collect(Collectors.toCollection(TreeSet::new));
        return contiguousDatesInRangeForLastNYears.equals(coveredDaysInLastNYears);
    }

    /**
     * Given a collection of {@link CoverDateRange}, then return the chronologically earliest end date of all the
     * {@link CoverDateRange} instances.
     *
     * @param coverDateRanges the range of dates.
     * @return the chronologically earliest {@link CoverDateRange#getTo()}.
     * @see CoverDateRange#getTo()
     */
    public static Optional<LocalDate> getEarliestEndDate(List<CoverDateRange> coverDateRanges) {
        return coverDateRanges.stream()
                .sorted(Comparator.comparing(CoverDateRange::getTo))
                .map(CoverDateRange::getTo)
                .findFirst();
    }

    /**
     * Given a collection of {@link CoverDateRange}, then return the chronologically earliest start date of all the
     * {@link CoverDateRange} instances.
     *
     * @param coverDateRanges the range of dates.
     * @return the chronologically earliest {@link CoverDateRange#getFrom()} ()}.
     * @see CoverDateRange#getFrom()
     */
    public static Optional<LocalDate> getEarliestStartDate(List<CoverDateRange> coverDateRanges) {
        return coverDateRanges.stream()
                .sorted(Comparator.comparing(CoverDateRange::getFrom))
                .map(CoverDateRange::getFrom)
                .findFirst();
    }

    /**
     * Given {@link LHCCalculationDetails}, return whether or not the respective applicant is eligible for minimum LHC.
     * <p>
     * Eligibility is true if an applicant
     * <ul>
     * <li>has stated they have always held continuous cover</li>
     * <li>has no applicable LHC cover days (i.e. aged less than 30 - {@link Constants#LHC_REQUIREMENT_AGE})</li>
     * <li>was born prior to the 1st June 1934 - {@link Constants#LHC_BIRTHDAY_APPLICABILITY_DATE}</li>
     * </ul>
     *
     * @param details the {@link LHCCalculationDetails}
     * @param onDay   the date of calculation.
     * @return true an applicant meets the above criteria.
     * @see #getLhcDaysApplicable(LocalDate, LocalDate)
     */
    public static boolean isEligibleForMinimumLHC(LHCCalculationDetails details, LocalDate onDay) {
        return details.getContinuousCover() || getLhcDaysApplicable(details.getDateOfBirth(), onDay) == 0;
    }
}
