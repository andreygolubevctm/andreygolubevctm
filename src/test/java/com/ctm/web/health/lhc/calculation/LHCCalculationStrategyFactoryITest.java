package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.google.common.collect.ImmutableList;
import org.junit.Ignore;
import org.junit.Test;

import java.time.LocalDate;
import java.time.Month;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import static com.ctm.web.health.lhc.calculation.Constants.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class LHCCalculationStrategyFactoryITest {

    public static final LocalDate TEST_CALCULATION_DATE = LocalDate.of(2018, 5, 15);

    @Test
    public void givenAlwaysHadCover_thenReturnMinLHC() {
        LocalDate thirtySeventhBirthday = TEST_CALCULATION_DATE.minusYears(37);
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(thirtySeventhBirthday)
                .isContinuousCover(true)
                .isNeverHadCover(false);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);

    }

    @Test
    public void givenNeverHadCover_thenCalculateLHC() {
        LocalDate thirtySeventhBirthday = TEST_CALCULATION_DATE.minusYears(37);
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(thirtySeventhBirthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(12, lhc);

    }

    @Test
    public void givenNoCoverOnBaseDate_whenExceededUncoveredThreshold_butCurrentlyHoldsTenYearsContiguousCover_thenReturnMinLHC() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(65);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TEST_CALCULATION_DATE.minusYears(11), TEST_CALCULATION_DATE));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
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

        assertEquals(34, lhc);
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
    public void givenCoverOnBaseDate_whenExceededUncoveredThreshold_andPreviouslyHeldTenYearsContiguousCover_thenCalculateLHC() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TEST_CALCULATION_DATE.minusYears(11), TEST_CALCULATION_DATE.minusYears(1)),
                new CoverDateRange(baseDate.minusDays(1), baseDate.plusDays(1)));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(8, lhc);
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

    /*
    @Test
    public void givenCoverOnBaseDate_whenExceededUncoveredThreshold_andNotHadTenYearsContiguousCover_thenCalculateLHC() {
        LocalDate birthday = TEST_CALCULATION_DATE.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(baseDate, baseDate.plusDays(LHC_DAYS_WITHOUT_COVER_THRESHOLD)));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(22, lhc);
    }
    */

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

        assertEquals(18, lhc);
    }


    @Test
    public void givenApplicant_whenBirthdayPriorToLHCApplicabilityDate_thenReturnMinimumLHC() {
        LocalDate preLHCBirthday = Constants.LHC_BIRTHDAY_APPLICABILITY_DATE.minusDays(1);

        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(preLHCBirthday)
                .isContinuousCover(false)
                .isNeverHadCover(false);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, TEST_CALCULATION_DATE).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
    }


    @Test
    public void givenBdayThisFinYear_whenAlreadyOccured_thenCalculateCorrectLHC() {
        LocalDate juneFirst = LocalDate.of(2018, 6, 1);

        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(LocalDate.of(1980, 3, 31))
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails, juneFirst).calculateLHCPercentage();

        assertEquals(14, lhc);
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

    @Test
    public void givenNeverHeldCover_whenBornAfterJulyFirstIn1961_thenReturn50PercentLHC() {
        LocalDate birthday = LocalDate.of(1961, 7, 2);
        LocalDate lhcCheckDate = LocalDate.of(2018, 6, 30);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
        assertEquals(50, lhc);
    }

    @Test
    public void givenNeverHeldCover_whenBornAfterJulyFirstIn1961_andBeforeJulyFirst1962_thenReturn50PercentLHC() {
        LocalDate birthday = LocalDate.of(1962, 3, 15);
        LocalDate lhcCheckDate = LocalDate.of(2018, 6, 30);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
        assertEquals(50, lhc);
    }

    @Test
    public void givenNeverHeldCover_whenBornOnJulyFirstIn1962_thenReturn50PercentLHC() {
        LocalDate birthday = LocalDate.of(1962, 7, 1);
        LocalDate lhcCheckDate = LocalDate.of(2018, 6, 30);
        LHCCalculationDetails neverHadCover = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        long lhc = LHCCalculationStrategyFactory.getInstance(neverHadCover, lhcCheckDate).calculateLHCPercentage();
        assertEquals(50, lhc);
    }
}
