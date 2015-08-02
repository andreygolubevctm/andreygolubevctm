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

@Pattern(regexp = "[\\w .'-]*")
@Size(min = 0, max = 200)
@ReportAsSingleViolation
@Target({ METHOD, FIELD })
@Retention(RUNTIME)
@Constraint(validatedBy = { })
public @interface Name {
    String message() default "Please enter alphabetic characters only. Unfortunately, " +
            "international alphabetic characters, numbers and symbols are not supported by many " +
            "of our partners at this time.";

    Class<?>[] groups() default { };

    /**
     * required fo hibernate validation
     **/
    Class<? extends Payload>[] payload() default { };
}