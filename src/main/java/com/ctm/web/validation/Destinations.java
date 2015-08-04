package com.ctm.web.validation;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.ReportAsSingleViolation;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
// ^(?!\s*$) = can't be blank
// ([A-Z]{3}+(?:,[A-Z]{3}+)*) = must be 3 characters in length (iso codes)
// (?:,[A-Z]{3}+) = optionally match a comma with another ISO code
@Pattern(regexp = "^(?!\\s*$)([A-Z]{3}+(?:,[A-Z]{3}+)*)$")
@Size(min = 0, max = 200)
@ReportAsSingleViolation
@Target({ METHOD, FIELD })
@Retention(RUNTIME)
@Constraint(validatedBy = { })
public @interface Destinations {
    String message() default "Please select your destination(s).";

    Class<?>[] groups() default { };

    /**
     * required fo hibernate validation
     **/
    Class<? extends Payload>[] payload() default { };
}