package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.Assert.assertEquals;

/**
 * Unit test for {@link LHCCalculationStrategyFactory}.
 */
public class LHCCalculationStrategyFactoryTest {

    private static final LocalDate DATE_OF_BIRTH = LocalDate.of(1981, 4, 1);
    private static final LocalDate BASE_DATE = LocalDate.of(2012, 7, 1);
    public static final LocalDate TEST_CALCULATION_DATE = LocalDate.of(2018, 7, 15);

    public static LHCCalculationDetails getValidCalculationDetails() {
        return new LHCCalculationDetails()
                .age(Constants.LHC_EXEMPT_AGE_CUT_OFF)
                .dateOfBirth(DATE_OF_BIRTH)
                .baseDate(BASE_DATE)
                .isContinuousCover(true)
                .lhcDaysApplicable(365)
                .isNeverHadCover(false);
    }

    @Test
    public void givenDetails_whenBornPriorToFirstJuly1934_thenReturnMinLHCCalculator() {
        LHCCalculationDetails lhcCalculationDetails = getValidCalculationDetails()
                .dateOfBirth(Constants.LHC_BIRTHDAY_APPLICABILITY_DATE.minusDays(1))
                .isContinuousCover(false);

        LHCCalculationStrategy calculator = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE);

        assertEquals(calculator.getClass(), MinimumLHCCalculationStrategy.class);
    }

    @Test
    public void givenDetails_whenContinuousCoverIsTrue_thenReturnCorrectCalculator() {
        LHCCalculationDetails lhcCalculationDetails = getValidCalculationDetails()
                .isContinuousCover(true);

        LHCCalculationStrategy calculator = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE);

        assertEquals(calculator.getClass(), MinimumLHCCalculationStrategy.class);
    }

    @Test
    public void givenDetails_whenNeveHeldCover_thenReturnCorrectCalculator() {
        LHCCalculationDetails lhcCalculationDetails = getValidCalculationDetails()
                .isContinuousCover(false)
                .isNeverHadCover(true);

        LHCCalculationStrategy calculator = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, LocalDate.now());

        assertEquals(calculator.getClass(), NeverHeldCoverCalculator.class);
    }

    @Test
    public void givenDetails_whenBaseDateInCoveredRange_thenReturnCorrectCalculator() {
        List<CoverDateRange> coverRange = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2012, 5, 10), LocalDate.of(2017, 5, 9))
        );
        LHCCalculationDetails lhcCalculationDetails = getValidCalculationDetails()
                .isContinuousCover(false)
                .coverDates(coverRange);

        LHCCalculationStrategy calculator = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, LocalDate.now());

        assertEquals(calculator.getClass(), HeldCoverOnBaseDateCalculator.class);
    }

    @Test
    public void givenDetails_whenBaseDateNotInCoveredRange_thenReturnCorrectCalculator() {
        List<CoverDateRange> threeSixtyFiveDaysOfCover = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2016, 5, 10), LocalDate.of(2017, 5, 9))
        );
        LHCCalculationDetails lhcCalculationDetails = getValidCalculationDetails()
                .isContinuousCover(false)
                .coverDates(threeSixtyFiveDaysOfCover);
        LHCCalculationStrategy calculator = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, LocalDate.now());

        assertEquals(calculator.getClass(), NoCoverOnBaseDateCalculator.class);
    }
}