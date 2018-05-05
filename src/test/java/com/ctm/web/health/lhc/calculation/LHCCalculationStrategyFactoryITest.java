package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.time.LocalDate;
import java.util.List;

import static com.ctm.web.health.lhc.calculation.Constants.LHC_DAYS_WITHOUT_COVER_THRESHOLD;
import static com.ctm.web.health.lhc.calculation.Constants.MAX_LHC_PERCENTAGE;
import static com.ctm.web.health.lhc.calculation.Constants.MIN_LHC_PERCENTAGE;
import static org.junit.Assert.assertEquals;

public class LHCCalculationStrategyFactoryITest {

    private static final LocalDate DATE_OF_BIRTH = LocalDate.of(1981, 4, 1);
    private static final LocalDate BASE_DATE = LocalDate.of(2012, 7, 1);
    private static final LocalDate TODAY = LocalDate.now();

    @Test
    public void givenAlwaysHadCover_thenReturnMinLHC() {
        LocalDate thirtySeventhBirthday = TODAY.minusYears(37);
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(thirtySeventhBirthday)
                .isContinuousCover(true)
                .isNeverHadCover(false);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);

    }

    @Test
    public void givenNeverHadCover_thenCalculateLHC() {
        LocalDate thirtySeventhBirthday = TODAY.minusYears(37);
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(thirtySeventhBirthday)
                .isContinuousCover(false)
                .isNeverHadCover(true);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(14, lhc);

    }

    @Test
    public void givenNoCoverOnBaseDate_whenExceededUncoveredThreshold_butCurrentlyHoldsTenYearsContiguousCover_thenReturnMinLHC() {
        LocalDate birthday = TODAY.minusYears(65);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TODAY.minusYears(11), TODAY));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
    }

    @Test
    public void givenNoCoverOnBaseDate_whenNotExceededUncoveredThreshold_orNotHadTenYearsContiguousCover_thenReturnMinLHC() {
        LocalDate birthday = TODAY.minusYears(33);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TODAY.minusYears(1), TODAY));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
    }

    @Test
    public void givenNoCoverOnBaseDate_whenExceededUncoveredThreshold_andNotHadTenYearsContiguousCover_thenCalculateLHC() {
        LocalDate birthday = TODAY.minusYears(65);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TODAY.minusYears(1), TODAY));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(68, lhc);
    }

    @Test
    public void givenNoCoverOnBaseDate_whenExceededUncoveredThreshold_whenNotHadTenYearsContiguousCover_whenExceedMaxLHCPercentage_thenReturnMaxLHCPercentage() {
        LocalDate birthday = TODAY.minusYears(70);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TODAY.minusYears(1), TODAY));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(MAX_LHC_PERCENTAGE, lhc);
    }

    @Test
    public void givenCoverOnBaseDate_whenExceededUncoveredThreshold_butCurrentlyHoldsTenYearsContiguousCover_thenReturnMinLHC() {
        LocalDate birthday = TODAY.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TODAY.minusYears(11), TODAY),
                new CoverDateRange(baseDate.minusDays(1), baseDate.plusDays(1)));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
    }

    @Test
    public void givenCoverOnBaseDate_whenExceededUncoveredThreshold_andPreviouslyHeldTenYearsContiguousCover_thenCalculateLHC() {
        LocalDate birthday = TODAY.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        List<CoverDateRange> coverDates = ImmutableList.of(new CoverDateRange(TODAY.minusYears(11), TODAY.minusYears(1)),
                new CoverDateRange(baseDate.minusDays(1), baseDate.plusDays(1)));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(8, lhc);
    }

    @Test
    public void givenCoverOnBaseDate_whenNotExceededUncoveredThreshold_orNotHadTenYearsContiguousCover_thenReturnMinLHC() {
        LocalDate birthday = TODAY.minusYears(37);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(baseDate, baseDate.plusDays(LHC_DAYS_WITHOUT_COVER_THRESHOLD)));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(MIN_LHC_PERCENTAGE, lhc);
    }

    @Test
    public void givenCoverOnBaseDate_whenExceededUncoveredThreshold_andNotHadTenYearsContiguousCover_thenCalculateLHC() {
        LocalDate birthday = TODAY.minusYears(65);
        LocalDate baseDate = LHCDateCalculationSupport.getBaseDate(birthday);
        List<CoverDateRange> coverDates = ImmutableList.of(
                new CoverDateRange(baseDate, baseDate.plusDays(LHC_DAYS_WITHOUT_COVER_THRESHOLD)));
        LHCCalculationDetails lhcCalculationDetails = new LHCCalculationDetails()
                .dateOfBirth(birthday)
                .isContinuousCover(false)
                .isNeverHadCover(false)
                .coverDates(coverDates);

        int lhc = LHCCalculationStrategyFactory.getInstance(lhcCalculationDetails).calculateLHCPercentage();

        assertEquals(22, lhc);
    }
}
