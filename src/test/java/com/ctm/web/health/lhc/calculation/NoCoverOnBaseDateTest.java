package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.ctm.web.health.lhc.model.response.LHCBaseDateDetails;
import com.google.common.collect.ImmutableList;
import org.junit.Ignore;
import org.junit.Test;

import java.time.LocalDate;
import java.time.Month;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import static com.ctm.web.health.lhc.calculation.Constants.*;
import static com.ctm.web.health.lhc.calculation.TestScenarioConstants.TEST_CALCULATION_DATE;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

/**
 * Test class containing scenarios when an applicant did not have cover on their base date.
 */
public class NoCoverOnBaseDateTest {

    /**
     * Scenario:
     * <ul>
     * <li>No cover on Base Date (2000-07-01)</li>
     * <li>Has exhausted all permitted gap days</li>
     * <li>Does not hold current cover on LHC check date</li>
     * <li>Exceeded MAX LHC (actual 72), returns MAX LHC of 70%</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_whenExceedsMaxLHC_thenReturnMaxLHCLimit() {
        LocalDate birthday = LocalDate.of(1944, Month.JUNE, 13);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(birthday);
        LHCCalculationDetails testLHCDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(1995, Month.OCTOBER, 1), LocalDate.of(1999, Month.JUNE, 25)),
                        new CoverDateRange(LocalDate.of(2006, Month.FEBRUARY, 28), LocalDate.of(2010, Month.MAY, 17))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(70, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>No cover on Base Date (2000-07-01)</li>
     * <li>Has exhausted all permitted gap days</li>
     * <li>Holds current cover on LHC check date</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andHasCurrentCover_thenCalculateLHC() {
        LocalDate birthday = LocalDate.of(1970, Month.JUNE, 13);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(birthday);
        LHCCalculationDetails testLHCDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(2005, Month.JUNE, 15), LocalDate.of(2005, Month.OCTOBER, 12)),
                        new CoverDateRange(LocalDate.of(2005, Month.DECEMBER, 25), LocalDate.of(2006, Month.JUNE, 6)),
                        new CoverDateRange(LocalDate.of(2010, Month.JULY, 2), LocalDate.of(2015, Month.NOVEMBER, 6)),
                        new CoverDateRange(LocalDate.of(2016, Month.FEBRUARY, 2), LocalDate.of(2016, Month.JUNE, 6)),
                        new CoverDateRange(LocalDate.of(2017, Month.FEBRUARY, 2), TestScenarioConstants.TEST_CALCULATION_DATE)

                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(14, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>Not cover on Base Date (2000-07-01)</li>
     * <li>Has exhausted all permitted gap days</li>
     * <li>Has no current cover on LHC check date</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_thenCalculateLHC_2() {
        LocalDate birthday = LocalDate.of(1967, Month.JUNE, 13);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(birthday);
        LHCCalculationDetails testLHCDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(2001, Month.OCTOBER, 1), LocalDate.of(2006, Month.JUNE, 25))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(26, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>Not cover on Base Date (2000-07-01)</li>
     * <li>Has not exhausted all permitted gap days (checked on 1093 day)</li>
     * <li>Has no current cover on LHC check date</li>
     * </ul>
     */
    @Test
    public void givenCover_whenCoverEnded_andNotExhaustedGapDays_thenLHCStaysTheSameAsTheFirstDayOfCover() {
        LocalDate lastDayOfGapPeriod = LocalDate.of(2011, Month.OCTOBER, 14);
        LocalDate birthday = LocalDate.of(1964, 11, 1);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(birthday);
        LHCCalculationDetails testCalcDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(2005, 10, 15), LocalDate.of(2008, 10, 15))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testCalcDetails, lastDayOfGapPeriod.minusDays(1)).calculateLHCPercentage();
        assertEquals(20, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>No Cover on Base Date (2000-07-01)</li>
     * <li>Exhausted all permitted gap days</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_thenCalculateLHC() {
        LocalDate birthday = LocalDate.of(1964, 11, 1);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(birthday);
        LHCCalculationDetails testLHCDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(2005, 10, 15), LocalDate.of(2008, 10, 15))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(32, lhc);
    }


    /**
     * Scenario:
     * <ul>
     * <li>No Cover on Base Date (2005-07-01)</li>
     * <li>Not exhausted all permitted gap days</li>
     * <li>Subsequently held 10 years contiguous cover (interrupted by permitted gap days)</li>
     * <li>Maintain current LHC cover on check date</li>
     * <li>Return Zero LHC</li>
     * </ul>
     */
    @Test
    public void givenTenYearsCover_whenInterruptedByPermittedGapDays_thenReturnZeroLHC() {
        LocalDate thirtySeventhBirthday = LocalDate.of(2005, 9, 22).minusYears(32);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(thirtySeventhBirthday);
        LocalDate LHC_CHECK_DATE = LocalDate.of(2018, Month.JUNE, 22);
        LHCCalculationDetails testCalcDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(thirtySeventhBirthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(2005, Month.SEPTEMBER, 26), LocalDate.of(2010, Month.SEPTEMBER, 26)),
                        new CoverDateRange(LocalDate.of(2013, Month.JUNE, 22), LHC_CHECK_DATE)));

        long lhc = LHCCalculationStrategyFactory.getInstance(testCalcDetails, LHC_CHECK_DATE).calculateLHCPercentage();

        assertEquals(0, lhc);
    }

    @Test
    public void givenNoCoverOnBaseDate_whenNotExceededUncoveredThreshold_orNotHadTenYearsContiguousCover_thenReturnMinLHC() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(33);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TEST_CALCULATION_DATE.minusYears(1), TEST_CALCULATION_DATE));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(NO_COVER_LHC_BASE_PERCENTAGE, lhc);
    }

    @Test
    public void givenNoCoverOnBaseDate_whenExceededUncoveredThreshold_andNotHadTenYearsContiguousCover_thenCalculateLHC() {
        LocalDate birthday = JULY_FIRST_2000.minusYears(LHC_EXEMPT_AGE_CUT_OFF);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TEST_CALCULATION_DATE.minusYears(1), TEST_CALCULATION_DATE));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(32, lhc);
    }



    @Test
    public void givenCoverOnBaseDate_whenExceededUncoveredThreshold_butCurrentlyHoldsTenYearsContiguousCover_thenReturnMinLHC() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TEST_CALCULATION_DATE.minusYears(11), TEST_CALCULATION_DATE),
                new CoverDateRange(baseDate.minusDays(1), baseDate.plusDays(1)));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
    }



    @Test
    public void givenCoverOnBaseDate_whenNotExceededUncoveredThreshold_orNotHadTenYearsContiguousCover_thenReturnMinLHC() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(37);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(baseDate, baseDate.plusDays(LHC_DAYS_WITHOUT_COVER_THRESHOLD)));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
    }



    @Test
    public void givenNoCoverOnBaseDate_whenApplicantHasZeroApplicableLHCDays_thenReturnZeroLHC() {
        LocalDate birthday = LocalDate.of(1998,7,1);
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2009,4,17), LocalDate.of(2010,3,31)),
                new CoverDateRange(LocalDate.of(2015,4,17), LocalDate.of(2016,3,31)),
                new CoverDateRange(LocalDate.of(2016,4,17), LocalDate.of(2017,3,31))
        );

        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
    }

    @Test
    public void givenNoCoverOnBaseDate_whenUsingTestExample2_thenCalculateLHC() {
        LocalDate birthday = LocalDate.of(1980,8,6);
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2014,3,11), LocalDate.of(2018,5,24))
        );

        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, LocalDate.of(2018,5,23)).calculateLHCPercentage();

        assertEquals(4, lhc);
    }

    @Test
    public void givenNoCoverOnBaseDate_whenUsingTestExample1_thenCalculateLHC() {
        LocalDate birthday = LocalDate.of(1964,11,1);
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(LocalDate.of(2005,10,15), LocalDate.of(2008,10,15))
        );

        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(32, lhc);
    }

    @Ignore("Long Execution time - but proves LHC Correctness for all values of a birthday in a given financial year")
    @Test
    public void givenNeverHeldCover_whenAged36OnFirstDayOfFinancialYear_thenLHCRemainsTheSame() {
        Set<LocalDate> daysInFinancialYear = LHCDateCalculationSupport.getCoveredDaysInRange(Collections.singletonList(new CoverDateRange(LocalDate.of(2017, Month.JULY, 1), LocalDate.of(2018, Month.JUNE, 30))));
        Set<LocalDate> daysAged36ForFinYear = LHCDateCalculationSupport.getCoveredDaysInRange(Collections.singletonList(new CoverDateRange(LocalDate.of(1980, Month.JULY, 2), LocalDate.of(1981, Month.JULY, 1))));

        daysAged36ForFinYear.forEach(birthday -> {
            daysInFinancialYear.forEach(lhcCheckDate -> {
                LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                        .dateOfBirth(birthday)
                        .isContinuousCover(false)
                        .isNeverHadCover(true);
                long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
                int expectedLHC = 12;
                if (lhc != expectedLHC) {
                    fail(String.format("Expected LHC to be '%1$d', but was '%2$d'. Birthday: '%3$s', LHC Check Date: '%4$s'", expectedLHC, lhc, birthday, lhcCheckDate));
                }
            });
        });
    }

    @Ignore("Long Execution time - but proves LHC Correctness for all values of a birthday in a given financial year")
    @Test
    public void givenNeverHeldCover_whenAged37OnFirstDayOfFinancialYear_thenLHCRemainsTheSame() {
        Set<LocalDate> daysInFinancialYear = LHCDateCalculationSupport.getCoveredDaysInRange(Collections.singletonList(new CoverDateRange(LocalDate.of(2017, Month.JULY, 1), LocalDate.of(2018, Month.JUNE, 30))));
        Set<LocalDate> daysAged37ForFinYear = LHCDateCalculationSupport.getCoveredDaysInRange(Collections.singletonList(new CoverDateRange(LocalDate.of(1979, Month.JULY, 2), LocalDate.of(1980, Month.JULY, 1))));

        daysAged37ForFinYear.forEach(birthday -> {
            daysInFinancialYear.forEach(lhcCheckDate -> {
                LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                        .dateOfBirth(birthday)
                        .isContinuousCover(false)
                        .isNeverHadCover(true);
                long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
                int expectedLHC = 14;
                if (lhc != expectedLHC) {
                    fail(String.format("Expected LHC to be '%1$d', but was '%2$d'. Birthday: '%3$s', LHC Check Date: '%4$s'", expectedLHC, lhc, birthday, lhcCheckDate));
                }
            });
        });
    }
}
