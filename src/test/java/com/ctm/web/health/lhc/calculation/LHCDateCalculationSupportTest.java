package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.health.lhc.calculation.Constants.JULY_FIRST_2000;
import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class LHCDateCalculationSupportTest {

    public static final LocalDate MIKES_BIRTHDAY = LocalDate.of(1981, 12, 23);
    public static final LocalDate MATTS_BIRTHDAY = LocalDate.of(1981, 5, 9);
    public static final LocalDate FIRST_JULY_BIRTHDAY = LocalDate.of(1981, 7, 1);
    public static final LocalDate SECOND_JULY_BIRTHDAY = FIRST_JULY_BIRTHDAY.plusDays(1);
    public static final LocalDate THIRTIETH_JUNE_BIRTHDAY = LocalDate.of(1981, 6, 30);
    public static final LocalDate THIRTY_ONE_YEARS_OLD = LocalDate.of(1969, 7, 1);
    public static final LocalDate TEST_DATE = LocalDate.of(2018, 5, 2);
    public static final int DAYS_BETWEEN_TEST_DATE_AND_FIRST_JULY_2000 = 6515;

    @Test
    public void givenDateAndDateOfBirth_thenCalculateAgeInYears() {
        long ageInYears = LHCDateCalculationSupport.calculateAgeInYearsFrom(MIKES_BIRTHDAY, TEST_DATE);
        assertEquals(36, ageInYears);
    }

    @Test
    public void givenDateOfBirth_thenCalculateAgeInYears() {
        LocalDate turnedOneToday = LocalDate.now().minusYears(1);
        long ageInYears = LHCDateCalculationSupport.calculateAgeInYears(turnedOneToday);
        assertEquals(1, ageInYears);
    }

    @Test
    public void givenDateOfBirthAfterJulyFirst2000_thenCalculateAgeOfZero() {
        assertEquals(0, LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(Constants.JULY_FIRST_2000.plusDays(1)));
    }

    @Test
    public void givenDateOfBirthOnJulyFirst2000_thenCalculateAgeOfZero() {
        assertEquals(0, LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(Constants.JULY_FIRST_2000));
    }


    @Test
    public void givenMikeysBirthday_thenCalculateAgeOnJulyFirst2000() {
        long ageInYearsAtJulyFirst2000 = LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(MIKES_BIRTHDAY);
        assertEquals(18, ageInYearsAtJulyFirst2000);
    }

    @Test
    public void givenMattsBirthday_thenCalculateAgeOnJulyFirst2000() {
        long ageInYearsAtJulyFirst2000 = LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(MATTS_BIRTHDAY);
        assertEquals(19, ageInYearsAtJulyFirst2000);
    }

    @Test
    public void givenFirstJulyBirthday_thenCalculateAgeOnJulyFirst2000() {
        long ageInYearsAtJulyFirst2000 = LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(FIRST_JULY_BIRTHDAY);
        assertEquals(19, ageInYearsAtJulyFirst2000);
    }


    @Test
    public void givenThirtiethJuneBirthday_thenCalculateAgeOnJulyFirst2000() {
        long ageInYearsAtJulyFirst2000 = LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(THIRTIETH_JUNE_BIRTHDAY);
        assertEquals(19, ageInYearsAtJulyFirst2000);
    }

    @Test
    public void givenSecondJulyBirthday_thenCalculateAgeOnJulyFirst2000() {
        long ageInYearsAtJulyFirst2000 = LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(SECOND_JULY_BIRTHDAY);
        assertEquals(18, ageInYearsAtJulyFirst2000);
    }

    @Test
    public void givenAgedGreaterThan31_onJulyFirst2000_thenReturnJulyFirst2000() {
        long ageInYearsAtJulyFirst2000 = LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(THIRTY_ONE_YEARS_OLD);
        assertEquals(31, ageInYearsAtJulyFirst2000);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(THIRTY_ONE_YEARS_OLD);
        assertEquals(JULY_FIRST_2000, baseDate);
    }

    @Test
    public void givenAged30_onJulyFirst2000_thenReturnJulyFirst2001() {
        LocalDate notQuiteThirty = THIRTY_ONE_YEARS_OLD.plusDays(1);
        long ageInYearsAtJulyFirst2000 = LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(notQuiteThirty);
        assertEquals(30, ageInYearsAtJulyFirst2000);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(notQuiteThirty);
        assertEquals(JULY_FIRST_2000.plusYears(1), baseDate);
    }

    @Test
    public void givenAgedLessThan31_onJulyFirst2000_thenCalculateLHCDaysApplicable() {
        long lhcDaysApplicable = LHCDateCalculationSupport.getLhcDaysApplicable(MIKES_BIRTHDAY, TEST_DATE);
        assertEquals(1767, lhcDaysApplicable);
    }

    @Test
    public void givenAgedGreaterThan31_onJulyFirst2000_thenReturn6514() {
        long lhcDaysApplicable = LHCDateCalculationSupport.getLhcDaysApplicable(THIRTY_ONE_YEARS_OLD, TEST_DATE);
        assertEquals(DAYS_BETWEEN_TEST_DATE_AND_FIRST_JULY_2000, lhcDaysApplicable);
    }

    @Test
    public void givenExtremeAgeValues__whenUsingTestDate_thenAlwaysReturnMaximumOf6514() {
        for (int ageOffset = 1; ageOffset < 1000; ageOffset++) {
            long lhcDaysApplicable = LHCDateCalculationSupport.getLhcDaysApplicable(THIRTY_ONE_YEARS_OLD.minusYears(ageOffset), TEST_DATE);
            assertEquals(DAYS_BETWEEN_TEST_DATE_AND_FIRST_JULY_2000, lhcDaysApplicable);
        }
    }

    @Test
    public void givenFutureDate_thenAlwaysReturn0() {
        for (int ageOffset = 1; ageOffset < 1000; ageOffset++) {
            LocalDate dateOfBirth = LocalDate.now().plusYears(ageOffset);
            long lhcDaysApplicable = LHCDateCalculationSupport.getLhcDaysApplicable(dateOfBirth, LocalDate.now());
            assertEquals(0, lhcDaysApplicable);
        }
    }

    @Test
    public void givenCoverDateRanges_whenBaseDateInRange_thenReturnTrue() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 10)),
                new CoverDateRange(LocalDate.of(2012, 1, 1), LocalDate.of(2012, 10, 5)),
                new CoverDateRange(LocalDate.of(2015, 11, 18), LocalDate.of(2016, 5, 10))
        );
        LocalDate baseDate = LocalDate.of(2012, 7, 1);

        boolean heldCoverOnBaseDate = LHCDateCalculationSupport.heldCoverOnBaseDate(baseDate, coverDates);

        assertTrue(heldCoverOnBaseDate);
    }

    @Test
    public void givenCoverDateRanges_whenBaseDateNotInRange_thenReturnFalse() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 10)),
                new CoverDateRange(LocalDate.of(2012, 1, 1), LocalDate.of(2012, 10, 5)),
                new CoverDateRange(LocalDate.of(2015, 11, 18), LocalDate.of(2016, 5, 10))
        );
        LocalDate baseDate = LocalDate.of(2010, 7, 1);

        boolean heldCoverOnBaseDate = LHCDateCalculationSupport.heldCoverOnBaseDate(baseDate, coverDates);

        assertFalse(heldCoverOnBaseDate);
    }

    @Test
    public void givenCoverDateRanges_whenBaseDateEqualsToDate_thenReturnTrue() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 10))
        );
        LocalDate baseDate = LocalDate.of(2017, 5, 10);

        boolean heldCoverOnBaseDate = LHCDateCalculationSupport.heldCoverOnBaseDate(baseDate, coverDates);

        assertTrue(heldCoverOnBaseDate);
    }

    @Test
    public void givenCoverDateRanges_whenBaseDateEqualsFromDate_thenReturnTrue() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 10))
        );
        LocalDate baseDate = LocalDate.of(2016, 5, 10);

        boolean heldCoverOnBaseDate = LHCDateCalculationSupport.heldCoverOnBaseDate(baseDate, coverDates);

        assertTrue(heldCoverOnBaseDate);
    }

    @Test
    public void givenCoverDateRangeOfOneYear_then365Days() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );
        long daysCovered = LHCDateCalculationSupport.getNumberOfDaysCovered(coverDates);

        assertEquals(365, daysCovered);
    }

    @Test
    public void givenCoverDateRangeOfOneYear_whenSpanningLeapYear_then366Days() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 1, 1), LocalDate.of(2016, 12, 31))
        );
        long daysCovered = LHCDateCalculationSupport.getNumberOfDaysCovered(coverDates);

        assertEquals(366, daysCovered);
    }

    @Test
    public void givenCoverDateRangeOfTwoYears_whenSpanningLeapYear_then731Days() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2015, 5, 10), LocalDate.of(2016, 5, 9)),
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );
        long daysCovered = LHCDateCalculationSupport.getNumberOfDaysCovered(coverDates);
        assertEquals(731, daysCovered);
    }

    @Test
    public void givenCoverDateRangeOfTwoYears_whenRangeIsNotContiguous_then730Days() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2014, 5, 10), LocalDate.of(2015, 5, 9)),
                new CoverDateRange(LocalDate.of(2017, 5, 10), LocalDate.of(2018, 5, 9))
        );
        long daysCovered = LHCDateCalculationSupport.getNumberOfDaysCovered(coverDates);
        assertEquals(730, daysCovered);
    }

    @Test
    public void givenCoverDateRange_whenGettingTheFirstDate_thenReturn() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2014, 5, 10), LocalDate.of(2015, 5, 9)),
                new CoverDateRange(LocalDate.of(2017, 5, 10), LocalDate.of(2018, 5, 9))
        );
        Optional<LocalDate> firstDayInRangeMaybe = LHCDateCalculationSupport.getFirstDayInRange(coverDates);

        assertTrue(firstDayInRangeMaybe.isPresent());
        LocalDate firstDayInRange = firstDayInRangeMaybe.get();
        assertEquals(LocalDate.of(2014, 5, 10), firstDayInRange);
    }


    @Test
    public void givenCoverDateRange_whenGettingTheLastDate_thenReturn() {
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2014, 5, 10), LocalDate.of(2015, 5, 9)),
                new CoverDateRange(LocalDate.of(2017, 5, 10), LocalDate.of(2018, 5, 9))
        );
        Optional<LocalDate> lastDayInRangeMaybe = LHCDateCalculationSupport.getLastDayInRange(coverDates);

        assertTrue(lastDayInRangeMaybe.isPresent());
        LocalDate lastDayInRange = lastDayInRangeMaybe.get();
        assertEquals(LocalDate.of(2018, 5, 9), lastDayInRange);
    }


    @Test
    public void givenContinousCoverDateRange_whenCheckingContiguousDates_thenReturnTrue() {
        List<CoverDateRange> contiguousCoverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2014, 5, 10), LocalDate.of(2024, 5, 9)),
                new CoverDateRange(LocalDate.of(2010, 5, 10), LocalDate.of(2014, 5, 9))
        );

        assertTrue(LHCDateCalculationSupport.isContiguous(contiguousCoverDates));
    }

    @Test
    public void givenNonContiguousCoverDateRange_whenCheckingContiguousDates_thenReturnFalse() {
        List<CoverDateRange> nonContiguousCoverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2014, 5, 10), LocalDate.of(2024, 5, 9)),
                new CoverDateRange(LocalDate.of(2010, 5, 10), LocalDate.of(2014, 5, 8))
        );
        assertFalse(LHCDateCalculationSupport.isContiguous(nonContiguousCoverDates));
    }


    @Test
    public void givenNYearsOfContiguousCoverDateRange_whenCheckingContiguousDates_thenEvaluateContiguity() {
        List<CoverDateRange> tenYrsContiguousWithABreak = ImmutableList.of(
                new CoverDateRange(LocalDate.now().minusYears(10), LocalDate.of(2024, 5, 9)),
                new CoverDateRange(LocalDate.of(2005, 5, 10), LocalDate.of(2009, 5, 9))
        );

        assertTrue(LHCDateCalculationSupport.hasYearsContiguousCover(10, tenYrsContiguousWithABreak, LocalDate.now()));
        assertFalse(LHCDateCalculationSupport.hasYearsContiguousCover(20, tenYrsContiguousWithABreak, LocalDate.now()));
    }

    @Test
    public void given10YearsCover_thenEvaluateContiguity() {
        LocalDate toDate = LocalDate.now();
        LocalDate fromDate = toDate.minusYears(10);
        List<CoverDateRange> tenYearsCover = ImmutableList.of(
                new CoverDateRange(fromDate, toDate)
        );

        assertTrue(LHCDateCalculationSupport.hasYearsContiguousCover(10, tenYearsCover, LocalDate.now()));
    }

    @Test
    public void givenEmptyCoverDateRange_thenReturnEmptyLastDayInRange() {
        List<CoverDateRange> emptyDateRanges = Collections.emptyList();
        Optional<LocalDate> lastDayInRange = LHCDateCalculationSupport.getLastDayInRange(emptyDateRanges);
        assertFalse(lastDayInRange.isPresent());
    }
}