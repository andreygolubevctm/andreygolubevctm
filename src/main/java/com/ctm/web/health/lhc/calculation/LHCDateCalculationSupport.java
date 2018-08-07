package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import org.elasticsearch.common.collect.ImmutableList;

import java.time.LocalDate;
import java.time.Month;
import java.time.chrono.ChronoLocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
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

    /**
     * Calculate an applicant's base date from their date of birth.
     *
     * The base date is the start of the financial year "after" (not after or equal to) their 31st birthday.
     * For example, with a date of July 1st, the start of the financial year following their 31st birthday, is in fact
     * their 32nd birthday.
     *
     * @param dateOfBirth the applicant's date of birth.
     * @return the start of the financial year following the 31st anniversary of a birthday.
     */
    public static LocalDate getBaseDate(LocalDate dateOfBirth) {
        long ageInYearsAtJulyFirst2000 = calculateAgeInYearsAtJulyFirst2000(dateOfBirth);

        if (ageInYearsAtJulyFirst2000 < Constants.LHC_EXEMPT_AGE_CUT_OFF) {
            return getFinancialYearStart(dateOfBirth.plusYears(Constants.LHC_EXEMPT_AGE_CUT_OFF + 1));
        } else {
            return Constants.JULY_FIRST_2000;
        }
    }

    /**
     * Return the unique number of days between a date of birth and the specified date that are applicable for LHC,
     * (between base date and now).
     * <p>
     * On the specified {@code onDay}, if a person born on {@code dateOfBirth}, calculate the number of days between
     * those two dates that occur between the calculated base date and {@code onDay}.
     * <p>
     * Unless the date of birth is on or before 01/07/1934, or the person is aged less than 31, in which case the days
     * applicable is ZERO.
     *
     * @param dateOfBirth the date of birth
     * @param onDay       the specified day for calculation.
     * @return the number of LHC applicable days.
     * @see #getBaseDate(LocalDate)
     */
    public static long getLhcDaysApplicable(LocalDate dateOfBirth, LocalDate onDay) {
        boolean agedLessThan31 = calculateAgeInYearsFrom(dateOfBirth, onDay) < Constants.LHC_EXEMPT_AGE_CUT_OFF;
        boolean bornOnOrBefore1934 = dateOfBirth.isBefore(Constants.LHC_BIRTHDAY_APPLICABILITY_DATE) ||
                dateOfBirth.isEqual(Constants.LHC_BIRTHDAY_APPLICABILITY_DATE);

        if (agedLessThan31 || bornOnOrBefore1934) {
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
     * Given a collection of {@link CoverDateRange}, calculate whether the entire coverage date range is contiguous from
     * the coverage end date for at least the given number of years.
     *
     * @param numberOfYears   the number of years from the coverage end date (inclusive)
     * @param coverDateRanges the range of dates to check for contiguous cover.
     * @param toDate          the end date for the coverage range.
     * @return true if the date range contains contiguous cover from the maximum cover date minus {@code numberOfYears}.
     */
    public static boolean hasYearsContiguousCover(int numberOfYears, List<CoverDateRange> coverDateRanges, LocalDate toDate) {
        return hasYearsContiguousCover(numberOfYears, toDate, getCoveredDaysInRange(coverDateRanges), Collections.emptyList());
    }

    /**
     * Given a collection of {@link CoverDateRange}, calculate whether the entire coverage date range is contiguous from
     * the coverage end date for at least the given number of years (accommodating for permitted gaps).
     *
     * @param numberOfYears   the number of years from the coverage end date (inclusive)
     * @param coverDateRanges the range of dates to check for contiguous cover.
     * @param toDate          the end date for the coverage range.
     * @param permittedGapDays the permitted gap days calculated as part of the cover date range.
     * @return true if the date range contains contiguous cover from the maximum cover date minus {@code numberOfYears},
     * accommodating permitted gaps up to a maximum of {@link Constants#LHC_DAYS_WITHOUT_COVER_THRESHOLD}.
     */
    public static boolean hasYearsContiguousCover(int numberOfYears, List<CoverDateRange> coverDateRanges, LocalDate toDate, List<LocalDate> permittedGapDays) {
        return hasYearsContiguousCover(numberOfYears, toDate, getCoveredDaysInRange(coverDateRanges), permittedGapDays);
    }

    /**
     * Given a collection of {@link CoverDateRange}, calculate whether the entire coverage date range is contiguous from
     * the coverage end date for at least the given number of years (accommodating for permitted gaps).
     *
     * @param numberOfYears the number of years from the coverage end date (inclusive)
     * @param toDate        the end date for the coverage range.
     * @param coverDates    the set of dates to check for contiguous cover.
     * @return true if the date range contains contiguous cover from the maximum cover date minus {@code numberOfYears}.
     */
    public static boolean hasYearsContiguousCover(int numberOfYears, LocalDate toDate, Set<LocalDate> coverDates) {
        return hasYearsContiguousCover(numberOfYears, toDate, coverDates, Collections.emptyList());
    }

    /**
     * Given a collection of {@link CoverDateRange}, calculate whether the entire coverage date range is contiguous from
     * the coverage end date for at least the given number of years (accommodating for permitted gaps).
     *
     * @param numberOfYears   the number of years from the coverage end date (inclusive)
     * @param toDate          the end date for the coverage range.
     * @param coverDates      the set of dates to check for contiguous cover.
     * @param permittedGapDays the permitted gap days calculated as part of the cover date range.
     * @return true if the date range contains contiguous cover from the maximum cover date minus {@code numberOfYears},
     * accommodating permitted gaps up to a maximum of {@link Constants#LHC_DAYS_WITHOUT_COVER_THRESHOLD}.
     */
    public static boolean hasYearsContiguousCover(int numberOfYears, LocalDate toDate, Set<LocalDate> coverDates, List<LocalDate> permittedGapDays) {
        coverDates.removeAll(permittedGapDays);
        LocalDate nYearsAgo = toDate.minusYears(numberOfYears).minusDays(Math.min(permittedGapDays.size(), Constants.LHC_DAYS_WITHOUT_COVER_THRESHOLD));
        CoverDateRange contiguousCoverDateRange = new CoverDateRange(nYearsAgo, toDate);
        Set<LocalDate> contiguousDatesInRangeForLastNYears = getCoveredDaysInRange(ImmutableList.of(contiguousCoverDateRange));
        Set<LocalDate> coveredDaysInLastNYears = coverDates.stream()
                .filter(l -> isInRange.apply(l, contiguousCoverDateRange))
                .collect(Collectors.toCollection(TreeSet::new));
        coveredDaysInLastNYears.addAll(permittedGapDays);
        return contiguousDatesInRangeForLastNYears.equals(coveredDaysInLastNYears);
    }

    /**
     * Returns July First (Start of the Financial Year) for the specified Date.
     *
     * @param date the date to find the beginning of the financial year for.
     * @return the date of the beginning of the financial year.
     */
    public static LocalDate getFinancialYearStart(LocalDate date) {
        final LocalDate newFinancialYear = date.withDayOfMonth(1).withMonth(Month.JULY.getValue());
        if (newFinancialYear.isBefore(date) || newFinancialYear.equals(date)) {
            return newFinancialYear;
        } else {
            return newFinancialYear.minusYears(1);
        }
    }

    /**
     * Return the date from which LHC calculation should begin. If a date of birth falls within a cover date range,
     * return {@link #getBaseDate(LocalDate)}, otherwise, return the start of the financial year after their 31st
     * Birthday.
     *
     * @param dateOfBirth the applicants date of birth
     * @param coverDates  the list of dates ranges for which an applicant held cover.
     * @return their LHC calculation start date.
     * @see #heldCoverOnBaseDate(LocalDate, List)
     */
    public static LocalDate getLHCCalculationStartDate(List<CoverDateRange> coverDates, LocalDate dateOfBirth) {
        final LocalDate baseDate = getBaseDate(dateOfBirth);
        final LocalDate lhcBeginDate;
        if (heldCoverOnBaseDate(baseDate, coverDates)) {
            lhcBeginDate = baseDate;
        } else {
            lhcBeginDate = getFinancialYearStart(dateOfBirth.plusYears(Constants.LHC_EXEMPT_AGE_CUT_OFF + 1));
        }
        return lhcBeginDate;
    }

    /**
     * Return the most recent date for which an applicant has held at least 10 years contiguous cover. This implementation
     * expects that any relevant gap days are included within the {@code allCoveredDaysAfterBaseDate} Set.
     *
     * @param allCoveredDaysAfterBaseDate all covered days (including permitted gap days).
     * @param firstNonGapDay              the first non permitted gap day.
     * @return either the most recent day for which an applicant had held 10 years cover, or {@link Optional#empty()}
     */
    public static Optional<LocalDate> getMostRecentLHCResetDate(Set<LocalDate> allCoveredDaysAfterBaseDate, LocalDate firstNonGapDay) {
        Optional<LocalDate> resetDate = Optional.empty();

        List<LocalDate> potentialLHCResetDates = allCoveredDaysAfterBaseDate.stream()
                .sorted(Comparator.reverseOrder())
                .filter(localDate -> localDate.isAfter(firstNonGapDay) || localDate.isEqual(firstNonGapDay))
                .collect(Collectors.toList());

        if (!potentialLHCResetDates.isEmpty()) {
            LocalDate earliestDate = potentialLHCResetDates.get(potentialLHCResetDates.size() - 1);

            for (LocalDate last : potentialLHCResetDates) {
                LocalDate tenYearsAgo = last.minusYears(Constants.CONTIGUOUS_YEARS_COVER_LHC_RESET_THRESHOLD);
                if (tenYearsAgo.isBefore(earliestDate)) {
                    break;
                } else {
                    List<LocalDate> localDates = potentialLHCResetDates.subList(potentialLHCResetDates.indexOf(last), potentialLHCResetDates.size() - 1);
                    if (hasYearsContiguousCover(Constants.CONTIGUOUS_YEARS_COVER_LHC_RESET_THRESHOLD, last, new TreeSet<>(localDates))) {
                        resetDate = Optional.of(last.plusDays(1));
                        break;
                    }
                }
            }
        }
        return resetDate;
    }

    public static Optional<LocalDate> getFirstNonCoveredDay(LocalDate initDate, LocalDate terminateDate, Set<LocalDate> coverDates) {
        return daysInclusive.apply(initDate, terminateDate).filter(localDate -> !coverDates.contains(localDate)).findFirst();
    }

    public static List<LocalDate> calculatePermittedGapDays(LocalDate initDate, LocalDate terminateDate, Set<LocalDate> coverDates) {
        final List<LocalDate> permittedGapDays = new ArrayList<>();
        LocalDate lastGapDay = initDate;
        int i = 0;
        while (lastGapDay.isBefore(terminateDate) && permittedGapDays.size() < Constants.LHC_DAYS_WITHOUT_COVER_THRESHOLD) {
            lastGapDay = initDate.plusDays(i++);
            if (!coverDates.contains(lastGapDay)) {
                permittedGapDays.add(lastGapDay);
            }
        }
        return permittedGapDays;
    }
}
