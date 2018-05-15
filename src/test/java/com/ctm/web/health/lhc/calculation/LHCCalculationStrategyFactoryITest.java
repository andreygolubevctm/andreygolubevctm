package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.time.LocalDate;
import java.util.List;

import static com.ctm.web.health.lhc.calculation.Constants.*;
import static org.junit.Assert.assertEquals;

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

        assertEquals(14, lhc);

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

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
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
}
