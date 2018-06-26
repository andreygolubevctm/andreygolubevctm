package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.ctm.web.health.lhc.model.response.LHCBaseDateDetails;
import org.junit.Test;

import java.time.LocalDate;

import static org.junit.Assert.assertEquals;

/**
 * Test scenarios containing tests for when an applicant has never held cover, or their cover dates are empty.
 */
public class NeverHeldCoverTest {

    /**
     * Scenario:
     * <ul>
     * <li>Never Held Cover (therefore ignore permitted gap days)</li>
     * <li>Base Date: 2012-07-01</li>
     * <li>Aged 37 on LHC Check Date 2018-06-22</li>
     * </ul>
     */
    @Test
    public void givenNeverHadCover_thenCalculateLHC() {
        LocalDate thirtySeventhBirthday = LocalDate.of(1981, 6, 22);
        LHCBaseDateDetails baseDateDetails = LHCBaseDateDetails.createFrom(thirtySeventhBirthday);
        LHCCalculationDetails testCalcDetails = new LHCCalculationDetails()
                .lhcDaysApplicable(baseDateDetails.getLhcDaysApplicable())
                .baseDate(baseDateDetails.getBaseDate())
                .age(baseDateDetails.getAge())
                .dateOfBirth(thirtySeventhBirthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(testCalcDetails, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(12, lhc);

    }

    @Test
    public void givenBornAfterJulyFirstIn1961_thenCalculateLHC() {
        LocalDate birthday = LocalDate.of(1961, 7, 2);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(50, lhc);
    }

    @Test
    public void givenBornAfterJulyFirstIn1961_andBeforeJulyFirst1962_thenCalculateLHC() {
        LocalDate birthday = LocalDate.of(1962, 3, 15);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(50, lhc);
    }

    @Test
    public void givenBornOnJulyFirstIn1962_thenCalculateLHC() {
        LocalDate birthday = LocalDate.of(1962, 7, 1);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, TestScenarioConstants.TEST_CALCULATION_DATE).calculateLHCPercentage();
        assertEquals(50, lhc);
    }

    @Test
    public void givenNeverHeldCover_whenBirthdayOnSameDayAsCheck_thenLHCIs14() {
        LocalDate birthday = LocalDate.of(1980, 7, 1);
        LocalDate lhcCheckDate = LocalDate.of(2017, 7, 1);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
        assertEquals(14, lhc);
    }

    @Test
    public void givenNeverHeldCover_whenBirthdayIsDayAfterCheck_thenLHCIs12() {
        LocalDate birthday = LocalDate.of(1980, 7, 2);
        LocalDate lhcCheckDate = LocalDate.of(2017, 7, 1);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
        assertEquals(12, lhc);
    }

    @Test
    public void givenNeverHeldCover_whenBirthdayIsDayBeforeCheck_thenLHCIs14() {
        LocalDate birthday = LocalDate.of(1980, 6, 30);
        LocalDate lhcCheckDate = LocalDate.of(2017, 7, 1);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
        assertEquals(14, lhc);
    }

    @Test
    public void givenNeverHeldCover_whenBornBeforeJulyFirstIn1962_thenReturn50PercentLHC() {
        LocalDate birthday = LocalDate.of(1962, 6, 15);
        LocalDate lhcCheckDate = LocalDate.of(2018, 6, 30);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
        assertEquals(50, lhc);
    }

    @Test
    public void givenNeverHeldCover_whenBornOnJulyFirstIn1961_thenReturn52PercentLHC() {
        LocalDate birthday = LocalDate.of(1961, 7, 1);
        LocalDate lhcCheckDate = LocalDate.of(2018, 6, 30);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
        assertEquals(52, lhc);
    }
}
