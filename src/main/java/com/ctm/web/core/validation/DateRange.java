package com.ctm.web.validation;


import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.ReportAsSingleViolation;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.ANNOTATION_TYPE;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * Validation annotation to validate that 2 fields are in a date range.
 * An array of fields and their matching dates fields can be supplied.
 *
 * Example, compare 1 pair of fields:
 * @FieldMatch(start = "effectiveStart", end = "effectiveEnd", message = "The password fields must match")
 *
 * Example, compare more than 1 pair of fields:
 * @FieldMatch.List({
 *   @FieldMatch(start = "effectiveStart", end = "effectiveEnd", message = "Effective Start must be before Effective End"),
 *   @FieldMatch(start = "effectiveStartTwo", end = "effectiveEndTwo", message = "effectiveStartTwo must be before effectiveEndTwo")})
 */
@Target({TYPE, ANNOTATION_TYPE})
@Retention(RUNTIME)
@Constraint(validatedBy = DateRangeValidator.class)
@ReportAsSingleViolation
@Documented
public @interface DateRange
{
    String message() default "{com.ctm.web.validation.daterange}";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * @return The start date field
     */
    String start();

    /**
     * @return The end date field
     */
    String end();

    /**
     * Defines several <code>@DateRange</code> annotations on the same element
     *
     * @see DateRange
     */
    @Target({TYPE, ANNOTATION_TYPE})
    @Retention(RUNTIME)
    @Documented
    @interface List
    {
        DateRange[] value();
    }
}