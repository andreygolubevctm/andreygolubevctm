package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.time.LocalDate;
import java.util.List;

import static com.ctm.web.health.lhc.calculation.Constants.*;
import static org.junit.Assert.assertEquals;


/**
 * Unit test for {@link NoCoverOnBaseDateCalculator}.
 */
public class NoCoverOnBaseDateCalculatorTest {

    public static final int LHC_DAYS_APPLICABLE = LHC_DAYS_WITHOUT_COVER_THRESHOLD * 2;
    public static final LocalDate TEST_CALCULATION_DATE = LocalDate.of(2018, 7, 15);

    @Test
    public void givenOneYearCoverage_whenAged32_thenReturnLHCPercentage() {
        LocalDate thirtySecondBirthday = TEST_CALCULATION_DATE.minusYears(32);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(thirtySecondBirthday);

        LocalDate coverStartDate = TEST_CALCULATION_DATE.minusYears(2);
        LocalDate coverEndDate = coverStartDate.plusYears(1);

        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(coverStartDate, coverEndDate)
        );
        long lhcPercentage = new NoCoverOnBaseDateCalculator(baseDate, threeSixtyFiveDaysOfCover, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(NO_COVER_LHC_BASE_PERCENTAGE, lhcPercentage);
    }

    @Test
    public void givenOneYearCoverage_whenAged40_thenReturnLHCPercentage() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(40);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        LocalDate coverStartDate = baseDate.plusYears(2);
        LocalDate coverEndDate = coverStartDate.plusYears(1);

        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(coverStartDate, coverEndDate)
        );

        long lhcPercentage= new NoCoverOnBaseDateCalculator(baseDate, threeSixtyFiveDaysOfCover, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(8, lhcPercentage);
    }

    @Test
    public void givenImplementation_testCase_thenCalculate16PercentLHC() {
        LocalDate birthday = Constants.JULY_FIRST_2000.minusYears(Constants.LHC_EXEMPT_AGE_CUT_OFF);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        assertEquals(Constants.JULY_FIRST_2000, baseDate);
        LocalDate coverStartDate = LocalDate.of(2005,10,15);
        LocalDate coverEndDate = LocalDate.of(2008,10,15);

        List<CoverDateRange> coverRange = ImmutableList.of(
                new CoverDateRange(coverStartDate, coverEndDate)
        );

        long lhcPercentage= new NoCoverOnBaseDateCalculator(baseDate, coverRange, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(18, lhcPercentage);
    }

    @Test
    public void givenOneYearCoverage_whenAged65_thenReturn68LHCPercentage() {
        LocalDate coverStartDate = TEST_CALCULATION_DATE.minusYears(2);
        LocalDate coverEndDate = coverStartDate.plusYears(1);
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);

        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(coverStartDate, coverEndDate)
        );

        long lhcPercentage= new NoCoverOnBaseDateCalculator(baseDate, threeSixtyFiveDaysOfCover, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(34, lhcPercentage);
    }

    @Test
    public void givenTwoYearsCoverage_whenAged65_thenReturn66LHCPercentage() {
        LocalDate toDate = TEST_CALCULATION_DATE;
        LocalDate fromDate = toDate.minusYears(2);
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);

        List<CoverDateRange> twoYearsOfCoverage = ImmutableList.of(
                new CoverDateRange(fromDate, toDate)
        );
        long lhcPercentage= new NoCoverOnBaseDateCalculator(baseDate, twoYearsOfCoverage, TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(34, lhcPercentage);
    }

    @Test
    public void givenTenYearsContiguousCover_thenReturnLHCPercentageOfZero() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        LocalDate toDate = TEST_CALCULATION_DATE;
        LocalDate fromDate = toDate.minusYears(10);
        List<CoverDateRange> tenYearsCover = ImmutableList.of(
                new CoverDateRange(fromDate, toDate)
        );

        long lhcPercentage= new NoCoverOnBaseDateCalculator(baseDate, tenYearsCover, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhcPercentage);
    }

    @Test
    public void givenOneDayLessThanTenYearsContiguousCover_thenReturnCalculatedLHCPercentage() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(55);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        LocalDate today = TEST_CALCULATION_DATE;
        LocalDate yesterday = today.minusDays(1);
        List<CoverDateRange> tenYearsCover = ImmutableList.of(
                new CoverDateRange(yesterday, today)
        );

        long lhcPercentage= new NoCoverOnBaseDateCalculator(baseDate, tenYearsCover, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(38, lhcPercentage);
    }
}