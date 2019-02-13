package com.ctm.web.health.quote.model.abd;

import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.model.form.HealthCover;
import com.ctm.web.health.model.form.Insured;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.IntStream;

/**
 * {@link AgeBasedDiscountCalculationSupport} provides support methods/functions for calculating Age Based Discount.
 */
public final class AgeBasedDiscountCalculationSupport {
    private static final Logger logger = LoggerFactory.getLogger(AgeBasedDiscountCalculationSupport.class);
    /**
     * The Maximum percentage applicable for Age Based Discount.
     */
    public static final int MAX_ABD_FACTOR = 10;
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
     * The First Date from which ABD may be calculated.
     */
    public static final LocalDate ABD_INTRO_DATE = LocalDate.of(2019, 4, 1);

    /**
     * Utility function to support parsing the date of birth from an {@link Insured} instance.
     * If the date cannot be parsed, an empty Optional will be returned.
     *
     * @see Insured#DOB_FORMATTER
     */
    private static Function<String, Optional<LocalDate>> safeParseBirthDate = dobString -> {
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
     * Calculates an Age Based Discount given a provided Age In Years.
     *
     * @param ageInYears the ageInYears from which to calculate the Age Based Discount
     * @return the Age Based Discount percentage
     */
    public static int calculateAgeBasedDiscountPercentage(int ageInYears) {
        int abdFactor = Math.max(THIRTY - ageInYears, 0) * 2;
        return Math.min(abdFactor, MAX_ABD_FACTOR);
    }

    /**
     * Calculate an Age Based Discount for multiple ages.
     * <p>
     * This algorithm uses {@link #calculateAgeBasedDiscountPercentage(int)}, for each age, and then takes the average.
     * In practice, this will either only be one, or two age elements, but this function will accept more.
     *
     * @param agesInYears a variadic param containing the ages in years from which to calculate the Age Based Discount
     * @return the Age Based Discount percentage considering all ages.
     */
    public static int calculateAgeBasedDiscountPercentage(int... agesInYears) {
        Optional<int[]> ages = Optional.ofNullable(agesInYears);
        final int divisor = ages.map(a -> a.length).orElse(1);
        return ages.map(Arrays::stream).orElse(IntStream.empty())
                .map(AgeBasedDiscountCalculationSupport::calculateAgeBasedDiscountPercentage)
                .reduce(Integer::sum).orElse(0) / divisor;
    }

    /**
     * Utility function to get the ABD Percentage from a HealthCover instance for a given date
     *
     * @param cover
     * @param date
     * @return
     */
    public static int getAbdPercentage(HealthCover cover, LocalDate date) {
        Function<Insured, Optional<Integer>> calculateABDAge = insured -> Optional.ofNullable(insured)
                .map(Insured::getDob)
                .flatMap(safeParseBirthDate)
                .map(dob -> calculateAgeInYearsFrom(dob, date));


        Optional<Insured> primaryApplicant = Optional.ofNullable(cover).map(HealthCover::getPrimary);
        Optional<Insured> secondaryApplicant = Optional.ofNullable(cover).map(HealthCover::getPartner);

        Integer primaryApplicantAge = primaryApplicant.flatMap(calculateABDAge).orElse(0);
        Optional<Integer> secondaryApplicantAge = secondaryApplicant.flatMap(calculateABDAge);

        return (int) secondaryApplicantAge
                .map(partnerAge -> calculateAgeBasedDiscountPercentage(primaryApplicantAge, partnerAge))
                .orElseGet(() -> calculateAgeBasedDiscountPercentage(primaryApplicantAge));
    }
}
