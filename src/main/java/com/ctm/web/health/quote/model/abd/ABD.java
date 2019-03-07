package com.ctm.web.health.quote.model.abd;

import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.quote.model.request.AbdDetails;
import com.ctm.web.health.quote.model.request.ProductType;
import org.elasticsearch.common.collect.ImmutableMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.IntStream;

import static java.util.Arrays.asList;

/**
 * {@link ABD} provides support methods/functions for calculating Age Based Discount.
 */
public final class ABD {
    private static final Logger logger = LoggerFactory.getLogger(ABD.class);
    /**
     * Describes the product types for which ABD may be applied.
     */
    public static final List<ProductType> APPLICABLE_PRODUCT_TYPES = asList(ProductType.COMBINED, ProductType.HOSPITAL);
    /**
     * The Maximum percentage applicable for Age Based Discount.
     */
    public static final int MAX_ABD_PERCENTAGE = 10;

    /**
     * Constant representing thirty years of age.
     * Before reaching the age of thirty, funds may choose to apply an age based discount.
     */
    public static final int THIRTY = 30;
    /**
     * Constant representing fourty one years of age.
     * After reaching the age of fourty one, age based discount percentage will begin to decrease by two percent,
     * per year, per policy holder.
     */
    public static final int FOURTY_ONE = 41;
    /**
     * Pre-calculated list of applicable Age Based Discount Percentages by age in years.
     */
    public static final Map<Integer, Integer> ABD_PERCENTAGES = ImmutableMap.<Integer, Integer>builder()
            .put(18, MAX_ABD_PERCENTAGE)
            .put(19, MAX_ABD_PERCENTAGE)
            .put(20, MAX_ABD_PERCENTAGE)
            .put(21, MAX_ABD_PERCENTAGE)
            .put(22, MAX_ABD_PERCENTAGE)
            .put(23, MAX_ABD_PERCENTAGE)
            .put(24, MAX_ABD_PERCENTAGE)
            .put(25, MAX_ABD_PERCENTAGE)
            .put(26, 8)
            .put(27, 6)
            .put(28, 4)
            .put(29, 2)
            .build();

    /**
     * Pre-calculated list of applicable Retained Age Based Discount Percentage reduction by age in years.
     */
    public static final Map<Integer, Integer> RABD_PERCENTAGE_DEDUCTIONS = ImmutableMap.<Integer, Integer>builder()
            .put(18, 0)
            .put(19, 0)
            .put(20, 0)
            .put(21, 0)
            .put(22, 0)
            .put(23, 0)
            .put(24, 0)
            .put(25, 0)
            .put(26, 0)
            .put(27, 0)
            .put(28, 0)
            .put(29, 0)
            .put(30, 0)
            .put(31, 0)
            .put(32, 0)
            .put(33, 0)
            .put(34, 0)
            .put(35, 0)
            .put(36, 0)
            .put(37, 0)
            .put(38, 0)
            .put(39, 0)
            .put(40, 0)
            .put(41, 2)
            .put(42, 4)
            .put(43, 6)
            .put(44, 8)
            .put(45, MAX_ABD_PERCENTAGE)
            .build();


    /**
     * The First Date from which ABD may be calculated.
     */
    public static final LocalDate ABD_INTRO_DATE = LocalDate.of(2019, 4, 1);

    /**
     * Utility function to support parsing the date of birth .
     * If the date cannot be parsed, an empty Optional will be returned.
     */
    public static Function<String, Optional<LocalDate>> safeParseDate = dobString -> {
        try {
            return Optional.ofNullable(LocalDate.parse(dobString, LocalDateUtils.AUS_FORMAT));
        } catch (DateTimeParseException ex) {
            logger.debug(String.format("Unable to parse Date of Birth String '%1$s'", ex));
            return Optional.empty();
        }
    };

    /**
     * Calculate the number of years from {@code dateOfBirth} until {@code assessmentDate}.
     * If a the {@code dateOfBirth} is not before {@code assessmentDate}, zero will be returned.
     * <p>
     * NB: ABD is not introduced until {@link #ABD_INTRO_DATE}, if assessmentDate is prior to {@link #ABD_INTRO_DATE}, then
     * we use {@link #ABD_INTRO_DATE} (01-Apr-2019).
     *
     * @param dateOfBirth    the date a person was born.
     * @param assessmentDate the date on which to calculate a person's age.
     * @return the number of whole years from {@code dateOfBirth} until {@code assessmentDate},
     * or the {@link #ABD_INTRO_DATE} - whichever is
     */
    public static int getCertifiedDiscountAge(LocalDate dateOfBirth, LocalDate assessmentDate) {
        if (!dateOfBirth.isBefore(assessmentDate)) {
            return 0;
        }

        final LocalDate abdAssessmentDate = Optional.of(assessmentDate)
                .filter(ABD_INTRO_DATE::isBefore)
                .orElse(ABD_INTRO_DATE);
        return getCurrentAge(dateOfBirth, abdAssessmentDate);
    }

    /**
     * Calculate the number of years from {@code dateOfBirth} until {@code assessmentDate}.
     * If a the {@code dateOfBirth} is not before {@code assessmentDate}, zero will be returned.
     * <p>
     * NB: ABD is not introduced until {@link #ABD_INTRO_DATE}, if assessmentDate is prior to {@link #ABD_INTRO_DATE}, then
     * we use {@link #ABD_INTRO_DATE} (01-Apr-2019).
     *
     * @param dateOfBirth    the date a person was born.
     * @param assessmentDate the date on which to calculate a person's age.
     * @return the number of whole years from {@code dateOfBirth} until {@code assessmentDate},
     * or the {@link #ABD_INTRO_DATE} - whichever is
     */
    public static int getCurrentAge(LocalDate dateOfBirth, LocalDate assessmentDate) {
        if (!dateOfBirth.isBefore(assessmentDate)) {
            return 0;
        }

        return Long.valueOf(ChronoUnit.YEARS.between(dateOfBirth, assessmentDate)).intValue();
    }


    /**
     * Returns the applicable Age Based Discount for the specified age.
     *
     * @param certifiedDiscountAge the certifiedDiscountAge from which to calculate the Age Based Discount
     * @return the Age Based Discount percentage
     */
    public static int getAgeBasedDiscount(int certifiedDiscountAge) {
        return ABD_PERCENTAGES.getOrDefault(certifiedDiscountAge, 0);
    }

    /**
     * Calculate an Age Based Discount for multiple ages.
     * <p>
     * This algorithm uses {@link #getAgeBasedDiscount(int)}, for each age, and then takes the average.
     * In practice, this will either only be one, or two age elements, but this function will accept more.
     *
     * @param certifiedDiscountAges a variadic param containing the ages in years from which to calculate the Age Based Discount
     * @return the Age Based Discount percentage considering all ages.
     */
    @Deprecated
    public static int getAgeBasedDiscount(int... certifiedDiscountAges) {
        Optional<int[]> ages = Optional.ofNullable(certifiedDiscountAges);
        final int divisor = ages.map(a -> a.length).orElse(1);
        return ages.map(Arrays::stream).orElse(IntStream.empty())
                .map(ABD::getAgeBasedDiscount)
                .reduce(Integer::sum).orElse(0) / divisor;
    }

    /**
     * Function to calculate the Age Based Discount details given the specified parameters.
     * <p>
     * NB: ABD is not introduced until {@link #ABD_INTRO_DATE}, if assessmentDate is prior to {@link #ABD_INTRO_DATE}, then
     * we use {@link #ABD_INTRO_DATE} (01-Apr-2019).
     *
     * @param dateOfBirth        the applicant's date of birth.
     * @param assessmentDate     the date on which to calculate a person's certified discount age.
     * @param abdPolicyStartDate an optional date describing the start of a previously started policy which applies age based discount.
     * @return
     */
    public static AbdDetails calculateAgeBasedDiscount(LocalDate dateOfBirth, LocalDate assessmentDate, Optional<LocalDate> abdPolicyStartDate) {

        int currentAge = getCurrentAge(dateOfBirth, assessmentDate);
        int certifiedDiscountAge = getCertifiedDiscountAge(dateOfBirth, abdPolicyStartDate.orElse(assessmentDate));

        int ageBasedDiscount = getAgeBasedDiscount(certifiedDiscountAge);
        int retainedAgeBasedDiscount = abdPolicyStartDate
                .map(ignored -> ABD.RABD_PERCENTAGE_DEDUCTIONS.getOrDefault(currentAge, MAX_ABD_PERCENTAGE)).orElse(0);

        return new AbdDetails(dateOfBirth, abdPolicyStartDate.orElse(assessmentDate), ageBasedDiscount, retainedAgeBasedDiscount, certifiedDiscountAge, currentAge);

    }
}
