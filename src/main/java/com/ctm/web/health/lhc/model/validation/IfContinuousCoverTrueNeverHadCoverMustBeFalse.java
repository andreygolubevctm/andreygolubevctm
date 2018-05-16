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
 * Validation annotation to validate when
 * {@link com.ctm.web.health.lhc.model.query.LHCCalculationDetails#isContinuousCover()} is true, then
 * {@link com.ctm.web.health.lhc.model.query.LHCCalculationDetails#isNeverHadCover()} cannot also be true.
 */
@Target({TYPE, ANNOTATION_TYPE})
@Retention(RUNTIME)
@Constraint(validatedBy = LHCCoverBooleanValidator.class)
@ReportAsSingleViolation
@Documented
public @interface IfContinuousCoverTrueNeverHadCoverMustBeFalse {

    String DEFAULT_MESSAGE_KEY = "";

    String message() default DEFAULT_MESSAGE_KEY;

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
