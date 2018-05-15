package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static com.ctm.web.health.lhc.calculation.Constants.*;
import static junitx.framework.Assert.assertEquals;

/**
 * Unit test for {@link HeldCoverOnBaseDateCalculator}
 */
public class HeldCoverOnBaseDateCalculatorTest {

    @Test
    public void givenExceededUncoveredDaysThresholdByOneYear_whenNotHadTenContiguousYearsCover_thenReturnLHCPercentage() {
        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );

        long lhcPercentage = new HeldCoverOnBaseDateCalculator(730 + LHC_DAYS_WITHOUT_COVER_THRESHOLD, threeSixtyFiveDaysOfCover).calculateLHCPercentage();

        assertEquals(2, lhcPercentage);
    }

    @Test
    public void givenNotExceededUncoveredDaysThresholdByOneYear_thenReturnLHCPercentageofZero() {
        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );

        long lhcPercentage = new HeldCoverOnBaseDateCalculator(LHC_DAYS_WITHOUT_COVER_THRESHOLD - 1, threeSixtyFiveDaysOfCover).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhcPercentage);
    }

    @Test
    public void givenExceededUncoveredDaysThresholdByOneYear_whenHadTenContiguousYearsCover_thenReturnLHCPercentageOfZero() {
        List<CoverDateRange> tenYearsContiguousCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2007, 5, 10), LocalDate.of(2017, 5, 9))
        );

        long lhcPercentage = new HeldCoverOnBaseDateCalculator(730 + LHC_DAYS_WITHOUT_COVER_THRESHOLD, tenYearsContiguousCover).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhcPercentage);
    }


    @Test
    public void givenOneYearOfCover_whenExceededUncoveredDaysThreshholdandMaxLHCPercentage_thenReturnMaxLHCThreshold() {
        List<CoverDateRange> oneYearOfCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );

        long lhcPercentage = new HeldCoverOnBaseDateCalculator(Integer.MAX_VALUE, oneYearOfCover).calculateLHCPercentage();
        assertEquals(MAX_LHC_PERCENTAGE, lhcPercentage);
    }

    @Test(expected = IllegalArgumentException.class)
    public void givenNegativeApplicableLHCDays_thenThrowIllegalArgumentException() {
        new HeldCoverOnBaseDateCalculator(Integer.MIN_VALUE, Collections.emptyList());
    }
}