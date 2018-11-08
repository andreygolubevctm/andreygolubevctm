package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.ctm.web.health.lhc.model.response.LHCBaseDateDetails;
import org.junit.Test;

import java.time.LocalDate;
import java.time.Month;
import java.util.Arrays;

import static org.junit.Assert.assertEquals;

/**
 * Tests containing scenarios when an applicant held cover on their base date.
 */
public class HadCoverOnBaseDateTest {

    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>Exhausted all permitted gap days prior to LHC Check Date</li>
     * <li>Dropped cover</li>
     * <li>NOT Held 10 years contiguous cover - including Permitted Gap days</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_andNotHeldTenYearsCover_thenCalculateLHC() {
        LocalDate birthday = LocalDate.of(1960, Month.JUNE, 13);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(birthday);
        LHCCalculationDetails testLHCDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(1999, Month.MAY, 26), LocalDate.of(2001, Month.OCTOBER, 1)),
                        new CoverDateRange(LocalDate.of(2006, Month.DECEMBER, 27), LocalDate.of(2010, Month.JULY, 30))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(22, lhc);
    }


    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>Exhausted all permitted gap days prior to LHC Check Date</li>
     * <li>Dropped cover</li>
     * <li>NOT Held 10 years contiguous cover - including Permitted Gap days</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_andNotHeldTenYearsCover_thenCalculateLHC_2() {
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
                        new CoverDateRange(LocalDate.of(1980, Month.JUNE, 15), LocalDate.of(2005, Month.OCTOBER, 12)),
                        new CoverDateRange(LocalDate.of(2006, Month.DECEMBER, 25), LocalDate.of(2008, Month.JUNE, 5)),
                        new CoverDateRange(LocalDate.of(2011, Month.JULY, 2), LocalDate.of(2011, Month.NOVEMBER, 6)),
                        new CoverDateRange(LocalDate.of(2012, Month.FEBRUARY, 12), LocalDate.of(2018, Month.MAY, 5))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(4, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>Held Cover on Base Date (2005-07-01)</li>
     * <li>Has exhausted all permitted gap days</li>
     * <li>Subsequently held 10 years contiguous cover (reset on 2022-05-06)</li>
     * <li>Drop cover on LHC check date (2022-06-22)</li>
     * <li>Return 2 percent LHC</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_andHeldTenYearsCover_thenCalculateFromTenYrResetDate() {
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
                        new CoverDateRange(LocalDate.of(1980, Month.JUNE, 15), LocalDate.of(2005, Month.OCTOBER, 12)),
                        new CoverDateRange(LocalDate.of(2006, Month.DECEMBER, 25), LocalDate.of(2008, Month.JUNE, 5)),
                        new CoverDateRange(LocalDate.of(2011, Month.JULY, 2), LocalDate.of(2011, Month.NOVEMBER, 6)),
                        new CoverDateRange(LocalDate.of(2012, Month.FEBRUARY, 12), LocalDate.of(2022, Month.MAY, 5))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, LocalDate.of(2022, Month.JUNE, 22)).calculateLHCPercentage();
        assertEquals(2, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>NOT Exhausted all permitted gap days prior to LHC Check Date</li>
     * <li>Dropped cove prior to LHC Check Date</li>
     * <li>Held 10 years contiguous cover - accommodating for Permitted Gap days</li>
     * </ul>
     */
    @Test
    public void givenNotExhaustedGapDays_andNoCurrentCover_andHeldTenYearsCoverWithPermittedGaps_thenReturnZero() {
        LocalDate birthday = LocalDate.of(1960, Month.JUNE, 13);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(birthday);
        LHCCalculationDetails testLHCDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(1999, Month.MAY, 26), LocalDate.of(2018, Month.JUNE, 5))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(Constants.MIN_LHC_PERCENTAGE, lhc);
    }


    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>Exhausted all permitted gap days</li>
     * <li>Not held 10 years cover after gap days expired</li>
     * <li>Dropped cover</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_andNotHeldTenYearsCover_thenCalculateLHC_3() {
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
                        new CoverDateRange(LocalDate.of(1980, Month.JUNE, 15), LocalDate.of(2005, Month.OCTOBER, 12)),
                        new CoverDateRange(LocalDate.of(2006, Month.DECEMBER, 25), LocalDate.of(2007, Month.JUNE, 5)),
                        new CoverDateRange(LocalDate.of(2016, Month.JULY, 2), LocalDate.of(2016, Month.NOVEMBER, 6))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(18, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>Exhausted all permitted gap days</li>
     * <li>Not held 10 years cover after gap days expired</li>
     * <li>Dropped cover</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_andNotHeldTenYearsCover_thenCalculateLHC_4() {
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
                        new CoverDateRange(LocalDate.of(1980, Month.JUNE, 15), LocalDate.of(2005, Month.OCTOBER, 12)),
                        new CoverDateRange(LocalDate.of(2006, Month.DECEMBER, 25), LocalDate.of(2008, Month.JUNE, 5)),
                        new CoverDateRange(LocalDate.of(2011, Month.JULY, 2), LocalDate.of(2016, Month.NOVEMBER, 6)),
                        new CoverDateRange(LocalDate.of(2017, Month.FEBRUARY, 12), LocalDate.of(2018, Month.MAY, 5))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(4, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>Not exhausted all permitted gap days</li>
     * <li>Dropped cover and not accrued LHC because of remaining gap days</li>
     * </ul>
     */
    @Test
    public void givenNotExhaustedGapDays_andNoCurrentCover_thenReturnZeroLHC() {
        LocalDate birthday = LocalDate.of(1960, Month.JUNE, 13);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(birthday);
        LHCCalculationDetails testLHCDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(Arrays.asList(
                        new CoverDateRange(LocalDate.of(1999, Month.MAY, 26), LocalDate.of(2017, Month.JUNE, 5))
                ));

        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(Constants.MIN_LHC_PERCENTAGE, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>Exhausted all permitted gap days</li>
     * <li>Subsequently held 10 years contiguous cover (Reset on 2022-05-06)</li>
     * <li>Dropped cover and accured subsequent LHC</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_andNoCurrentCover_andHeldTenYearsCover_thenCalculateFromTenYrResetDate_2() {
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
                        new CoverDateRange(LocalDate.of(1980, Month.JUNE, 15), LocalDate.of(2005, Month.OCTOBER, 12)),
                        new CoverDateRange(LocalDate.of(2006, Month.DECEMBER, 25), LocalDate.of(2008, Month.JUNE, 5)),
                        new CoverDateRange(LocalDate.of(2011, Month.JULY, 2), LocalDate.of(2011, Month.NOVEMBER, 6)),
                        new CoverDateRange(LocalDate.of(2012, Month.FEBRUARY, 12), LocalDate.of(2022, Month.MAY, 5))
                ));

        LocalDate LHC_CHECK_DATE = LocalDate.of(2027, Month.JUNE, 22);
        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, LHC_CHECK_DATE).calculateLHCPercentage();
        assertEquals(12, lhc);
    }

    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>Exhausted all permitted gap days</li>
     * <li>Subsequently held 10 years contiguous cover</li>
     * <li>Dropped cover and accured 2% LHC</li>
     * <li>Checked LHC prior to the turn of the financial year</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_whenHadPreviousTenYearsCover_andDroppedCover_thenResetLHC_andAccrueTwoPercentBeforeFinYearEnd() {
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
                        new CoverDateRange(LocalDate.of(1980, Month.JUNE, 15), LocalDate.of(2005, Month.OCTOBER, 12)),
                        new CoverDateRange(LocalDate.of(2006, Month.DECEMBER, 25), LocalDate.of(2008, Month.JUNE, 5)),
                        new CoverDateRange(LocalDate.of(2011, Month.JULY, 2), LocalDate.of(2011, Month.NOVEMBER, 6)),
                        new CoverDateRange(LocalDate.of(2012, Month.FEBRUARY, 12), LocalDate.of(2022, Month.MAY, 5))
                ));

        LocalDate LHC_CHECK_DATE = LocalDate.of(2022, Month.JUNE, 22);
        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, LHC_CHECK_DATE).calculateLHCPercentage();
        assertEquals(2, lhc);
    }


    /**
     * Scenario:
     * <ul>
     * <li>Had Cover on Base Date (2000-07-01)</li>
     * <li>Exhausted all permitted gap days</li>
     * <li>Subsequently held 10 years contiguous cover</li>
     * <li>Dropped cover and accured 2% LHC</li>
     * <li>Checked LHC after to the turn of the financial year</li>
     * </ul>
     */
    @Test
    public void givenExhaustedGapDays_whenHadPreviousTenYearsCover_andDroppedCover_thenResetLHC_andAccrueTwoPercentAfterFinYearEnd() {
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
                        new CoverDateRange(LocalDate.of(1980, Month.JUNE, 15), LocalDate.of(2005, Month.OCTOBER, 12)),
                        new CoverDateRange(LocalDate.of(2006, Month.DECEMBER, 25), LocalDate.of(2008, Month.JUNE, 5)),
                        new CoverDateRange(LocalDate.of(2011, Month.JULY, 2), LocalDate.of(2011, Month.NOVEMBER, 6)),
                        new CoverDateRange(LocalDate.of(2012, Month.FEBRUARY, 12), LocalDate.of(2022, Month.MAY, 5))
                ));

        LocalDate LHC_CHECK_DATE = LocalDate.of(2022, Month.JULY, 22);
        long lhc = LHCCalculationStrategyFactory.getInstance(testLHCDetails, LHC_CHECK_DATE).calculateLHCPercentage();
        assertEquals(2, lhc);
    }

}
