package com.ctm.web.health.quote.model.abd;

import com.ctm.web.core.utils.common.utils.LocalDateUtils;
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
     * Calculate the number of years from {@code dateOfBirth} until {@code untilDay}.
     * If a the {@code dateOfBirth} is not before {@code untilDay}, zero will be returned.
     * <p>
     * NB: ABD is not introduced until {@link #ABD_INTRO_DATE}, if untilDay is prior to {@link #ABD_INTRO_DATE}, then
     * we use {@link #ABD_INTRO_DATE} (01-Apr-2019).
     *
     * @param dateOfBirth the date a person was born.
     * @param untilDay    the date on which to calculate a person's age.
     * @return the number of whole years from {@code dateOfBirth} until {@code untilDay}.
     */
    public static int calculateAgeInYearsFrom(LocalDate dateOfBirth, LocalDate untilDay) {
        if (!dateOfBirth.isBefore(untilDay)) {
            return 0;
        }

        final LocalDate calculationDay = Optional.of(untilDay)
                .filter(ABD_INTRO_DATE::isBefore)
                .orElse(ABD_INTRO_DATE);
        return Long.valueOf(ChronoUnit.YEARS.between(dateOfBirth, calculationDay)).intValue();
    }

    /**
     * Returns the applicable Age Based Discount for the specified age.
     *
     * @param ageInYears the ageInYears from which to calculate the Age Based Discount
     * @return the Age Based Discount percentage
     */
    public static int getAgeBasedDiscount(int ageInYears) {
        return ABD_PERCENTAGES.getOrDefault(ageInYears, 0);
    }

    /**
     * Calculate an Age Based Discount for multiple ages.
     * <p>
     * This algorithm uses {@link #getAgeBasedDiscount(int)}, for each age, and then takes the average.
     * In practice, this will either only be one, or two age elements, but this function will accept more.
     *
     * @param agesInYears a variadic param containing the ages in years from which to calculate the Age Based Discount
     * @return the Age Based Discount percentage considering all ages.
     */
    public static int getAgeBasedDiscount(int... agesInYears) {
        Optional<int[]> ages = Optional.ofNullable(agesInYears);
        final int divisor = ages.map(a -> a.length).orElse(1);
        return ages.map(Arrays::stream).orElse(IntStream.empty())
                .map(ABD::getAgeBasedDiscount)
                .reduce(Integer::sum).orElse(0) / divisor;
    }

    /**
     * Utility function to get the ABD Percentage from a HealthCover instance for a given date
     *
     * @param primaryDob     the Primary applicant's date of birth.
     * @param partnerDob     the Partner applicant's date of birth.
     * @param assessmentDate the ABD assessment date.
     * @return the Age Based Discount percentage.
     */
    public static int calculateAgeBasedDiscount(Optional<String> primaryDob, Optional<String> partnerDob, LocalDate assessmentDate) {
        Function<String, Optional<Integer>> calculateABDAge = applicantDob -> Optional.ofNullable(applicantDob)
                .flatMap(safeParseDate)
                .map(dob -> calculateAgeInYearsFrom(dob, assessmentDate));


        Integer primaryApplicantAge = primaryDob.flatMap(calculateABDAge).orElse(0);
        Optional<Integer> secondaryApplicantAge = partnerDob.flatMap(calculateABDAge);

        return secondaryApplicantAge
                .map(partnerAge -> getAgeBasedDiscount(primaryApplicantAge, partnerAge))
                .orElseGet(() -> getAgeBasedDiscount(primaryApplicantAge));
    }
}
