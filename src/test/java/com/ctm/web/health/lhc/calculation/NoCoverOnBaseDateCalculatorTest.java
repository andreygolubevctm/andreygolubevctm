package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static com.ctm.web.health.lhc.calculation.Constants.*;
import static junit.framework.Assert.assertEquals;

/**
 * Unit test for {@link NoCoverOnBaseDateCalculator}.
 */
public class NoCoverOnBaseDateCalculatorTest {

    public static final int LHC_DAYS_APPLICABLE = LHC_DAYS_WITHOUT_COVER_THRESHOLD * 2;

    @Test(expected = IllegalArgumentException.class)
    public void givenNegativeApplicableLHCDays_thenThrowIllegalArgumentException() {
        new NoCoverOnBaseDateCalculator(Integer.MIN_VALUE, 1, Collections.emptyList());
    }

    @Test(expected = IllegalArgumentException.class)
    public void givenNegativeApplicantAge_thenThrowIllegalArgumentException() {
        new NoCoverOnBaseDateCalculator(1, Integer.MIN_VALUE, Collections.emptyList());
    }

    @Test
    public void givenOneYearCoverage_whenAged32_thenReturnLHCPercentage() {
        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );

        int lhcPercentage = new NoCoverOnBaseDateCalculator(LHC_DAYS_APPLICABLE, 32, threeSixtyFiveDaysOfCover).calculateLHCPercentage();

        assertEquals(2, lhcPercentage);
    }

    @Test
    public void givenOneYearCoverage_whenAged33_thenReturnLHCPercentage() {
        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );

        int lhcPercentage = new NoCoverOnBaseDateCalculator(LHC_DAYS_APPLICABLE, 33, threeSixtyFiveDaysOfCover).calculateLHCPercentage();

        assertEquals(4, lhcPercentage);
    }

    @Test
    public void givenOneYearCoverage_whenAccruedMaxPercentage_thenReturnMaxLHCPercentage() {
        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );

        int lhcPercentage = new NoCoverOnBaseDateCalculator(LHC_DAYS_APPLICABLE, 70, threeSixtyFiveDaysOfCover).calculateLHCPercentage();

        assertEquals(MAX_LHC_PERCENTAGE, lhcPercentage);
    }

    @Test
    public void givenOneYearCoverage_whenAged65_thenReturn68LHCPercentage() {
        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );

        int lhcPercentage = new NoCoverOnBaseDateCalculator(LHC_DAYS_APPLICABLE, 65, threeSixtyFiveDaysOfCover).calculateLHCPercentage();

        assertEquals(68, lhcPercentage);
    }

    @Test
    public void givenTwoYearsCoverage_whenAged65_thenReturn66LHCPercentage() {
        LocalDate toDate = LocalDate.now();
        LocalDate fromDate = toDate.minusYears(2);
        List<CoverDateRange> twoYearsOfCoverage = ImmutableList.of(
                new CoverDateRange(fromDate, toDate)
        );
        int lhcPercentage = new NoCoverOnBaseDateCalculator(LHC_DAYS_APPLICABLE, 65, twoYearsOfCoverage).calculateLHCPercentage();
        assertEquals(66, lhcPercentage);
    }

    @Test
    public void givenTenYearsContiguousCover_thenReturnLHCPercentageOfZero() {
        LocalDate toDate = LocalDate.now();
        LocalDate fromDate = toDate.minusYears(10);
        List<CoverDateRange> tenYearsCover = ImmutableList.of(
                new CoverDateRange(fromDate, toDate)
        );

        int lhcPercentage = new NoCoverOnBaseDateCalculator(LHC_DAYS_APPLICABLE, 65, tenYearsCover).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhcPercentage);
    }

    @Test
    public void givenOneDayLessThanTenYearsContiguousCover_thenReturnCalculatedLHCPercentage() {
        LocalDate today = LocalDate.now();
        LocalDate yesterday = today.minusDays(1);
        List<CoverDateRange> tenYearsCover = ImmutableList.of(
                new CoverDateRange(yesterday, today)
        );

        int lhcPercentage = new NoCoverOnBaseDateCalculator(LHC_DAYS_APPLICABLE, 55, tenYearsCover).calculateLHCPercentage();

        assertEquals(50, lhcPercentage);
    }
}