package com.ctm.web.health.lhc.model.validation;

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
 * Validation the {@link com.ctm.web.health.lhc.model.query.CoverDateRange#getTo()}
 * is equal or after {@link com.ctm.web.health.lhc.model.query.CoverDateRange#getFrom()}
 */
@Target({TYPE, ANNOTATION_TYPE})
@Retention(RUNTIME)
@Constraint(validatedBy = ToDateMustBeAfterFromDateValidator.class)
@ReportAsSingleViolation
@Documented
public @interface ToDateIsEqualOrAfterFromDate {

    String DEFAULT_MESSAGE_KEY = "";

    String message() default DEFAULT_MESSAGE_KEY;

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
