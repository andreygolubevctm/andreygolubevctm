package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.time.LocalDate;
import java.time.Month;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import static com.ctm.web.health.lhc.calculation.Constants.JULY_FIRST_2000;
import static com.ctm.web.health.lhc.calculation.TestScenarioConstants.*;
import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class LHCDateCalculationSupportTest {

    @Test
    public void givenDateAndDateOfBirth_thenCalculateAgeInYears() {
        long ageInYears = LHCDateCalculationSupport.calculateAgeInYearsFrom(MIKES_BIRTHDAY, TEST_DATE);
        assertEquals(36, ageInYears);
    }

    @Test
    public void givenDateOfBirth_thenCalculateAgeInYears() {
        LocalDate turnedOneToday = LocalDate.now().minusYears(1);
        long ageInYears = LHCDateCalculationSupport.calculateAgeInYearsFrom(turnedOneToday, LocalDate.now());
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
        long ageInYearsAtJulyFirst2000 = LHCDateCalculationSupport.calculateAgeInYearsAtJulyFirst2000(FIRST_JULY_1969);
        assertEquals(31, ageInYearsAtJulyFirst2000);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(FIRST_JULY_1969);
        assertEquals(JULY_FIRST_2000, baseDate);
    }

    @Test
    public void givenAged30_onJulyFirst2000_thenReturnJulyFirst2001() {
        LocalDate notQuiteThirty = FIRST_JULY_1969.plusDays(1);
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
    public void givenAgedGreaterThan31_onJulyFirst2000_thenReturnMAXLHCDays() {
        long lhcDaysApplicable = LHCDateCalculationSupport.getLhcDaysApplicable(FIRST_JULY_1969, TEST_DATE);
        assertEquals(MAX_LHC_APPLICABLE_DAYS, lhcDaysApplicable);
    }

    @Test
    public void givenBirthday_whenBornBeforeJulyFirst1934_thenReturnZeroLHCApplicableDays() {

        LocalDate beforeLHCApplicabilityDate = Constants.LHC_BIRTHDAY_APPLICABILITY_DATE.minusDays(1);
        long lhcDaysApplicable = LHCDateCalculationSupport.getLhcDaysApplicable(beforeLHCApplicabilityDate, TEST_DATE);
        assertEquals(0, lhcDaysApplicable);
    }

    @Test
    public void givenBirthday_whenBornOnJulyFirst1934_thenReturnZeroLHCApplicableDays() {

        LocalDate beforeLHCApplicabilityDate = Constants.LHC_BIRTHDAY_APPLICABILITY_DATE;
        long lhcDaysApplicable = LHCDateCalculationSupport.getLhcDaysApplicable(beforeLHCApplicabilityDate, TEST_DATE);
        assertEquals(MAX_LHC_APPLICABLE_DAYS, lhcDaysApplicable);
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
    public void givenNYearsOfContiguousCoverDateRange_whenCheckingContiguousDates_thenEvaluateContiguity() {
        List<CoverDateRange> tenYrsContiguousWithABreak = ImmutableList.of(
                new CoverDateRange(LocalDate.now().minusYears(10), LocalDate.of(2024, 5, 9)),
                new CoverDateRange(LocalDate.of(2005, 5, 10), LocalDate.of(2009, 5, 9))
        );

        assertTrue(LHCDateCalculationSupport.hasYearsContiguousCover(10, tenYrsContiguousWithABreak, LocalDate.now()));
        assertFalse(LHCDateCalculationSupport.hasYearsContiguousCover(20, tenYrsContiguousWithABreak, LocalDate.now()));
    }

    @Test
    public void givenInterruptedCover_whenPermittedGapDays_thenReturnTrue() {
        List<CoverDateRange> tenYrsContiguousWithAPermittedBreak = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2005, Month.SEPTEMBER, 26), LocalDate.of(2010, Month.SEPTEMBER, 26)),
                new CoverDateRange(LocalDate.of(2013, Month.JUNE, 22), LocalDate.of(2018, Month.JUNE, 22))
        );

        Set<LocalDate> permittedGaps = LHCDateCalculationSupport.getCoveredDaysInRange(Collections.singletonList(
                new CoverDateRange(LocalDate.of(2010, Month.SEPTEMBER, 27), LocalDate.of(2013, Month.JUNE, 21))
        ));

        assertTrue(LHCDateCalculationSupport.hasYearsContiguousCover(10, tenYrsContiguousWithAPermittedBreak, LocalDate.of(2018, Month.JUNE, 22), new ArrayList(permittedGaps)) );
    }

    @Test
    public void givenInterruptedCover_whenPermittedGapDays_andNonPermittedGapDays_thenReturnFalse() {
        List<CoverDateRange> tenYrsContiguousWithAPermittedBreak = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2005, Month.SEPTEMBER, 26), LocalDate.of(2010, Month.SEPTEMBER, 26)),
                new CoverDateRange(LocalDate.of(2015, Month.JUNE, 22), LocalDate.of(2018, Month.JUNE, 22))
        );

        Set<LocalDate> exceededGaps = LHCDateCalculationSupport.getCoveredDaysInRange(Collections.singletonList(
                new CoverDateRange(LocalDate.of(2010, Month.SEPTEMBER, 27), LocalDate.of(2015, Month.JUNE, 21))
        ));

        assertFalse(LHCDateCalculationSupport.hasYearsContiguousCover(10, tenYrsContiguousWithAPermittedBreak, LocalDate.of(2018, Month.JUNE, 22), new ArrayList(exceededGaps)) );
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
    public void givenDate_whenFinYearStartedLastYear_thenReturnStartOfFinancialYear() {
        LocalDate testDate = LocalDate.of(2018, Month.JUNE, 30);

        LocalDate financialYearStart = LHCDateCalculationSupport.getFinancialYearStart(testDate);

        assertEquals(LocalDate.of(2017, Month.JULY, 1), financialYearStart);
    }

    @Test
    public void givenDate_whenFinYearStartedThisYear_thenReturnStartOfFinancialYear() {
        LocalDate testDate = LocalDate.of(2018, Month.AUGUST, 15);

        LocalDate financialYearStart = LHCDateCalculationSupport.getFinancialYearStart(testDate);

        assertEquals(LocalDate.of(2018, Month.JULY, 1), financialYearStart);
    }

    @Test
    public void givenDate_whenFinYearStartsToday_thenReturnStartOfFincancialYear() {
        LocalDate testDate = LocalDate.of(2018, Month.JULY, 1);

        LocalDate financialYearStart = LHCDateCalculationSupport.getFinancialYearStart(testDate);

        assertEquals(LocalDate.of(2018, Month.JULY, 1), financialYearStart);
    }

    @Test
    public void givenBirthdayOnFirstJuly_thenBaseDateCalculatedFromFollowingFirstJuly() {
        LocalDate birthday = LocalDate.of(1979, Month.JULY, 1);

        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);

        assertEquals(LocalDate.of(2011, Month.JULY, 1), baseDate);
    }

    @Test
    public void givenBirthdayOnSecondJuly_thenBaseDateCalculatedFromFollowingFirstJuly() {
        LocalDate birthday = LocalDate.of(1979, Month.JULY, 2);

        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);

        assertEquals(LocalDate.of(2011, Month.JULY, 1), baseDate);
    }

    @Test
    public void givenBirthdayOnThirtyJune_thenBaseDateCalculatedFromFollowingFirstJuly() {
        LocalDate birthday = LocalDate.of(1979, Month.JUNE, 30);

        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);

        assertEquals(LocalDate.of(2010, Month.JULY, 1), baseDate);
    }
}