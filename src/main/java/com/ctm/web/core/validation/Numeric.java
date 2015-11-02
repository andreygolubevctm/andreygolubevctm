package com.ctm.web.core.validation;

import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.ReportAsSingleViolation;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

@Pattern(regexp = "[\\d]*")
@Size(min = 0, max = 200)
@ReportAsSingleViolation
@Target({ METHOD, FIELD })
@Retention(RUNTIME)
@Constraint(validatedBy = { })
public @interface Numeric {
	String message() default "Please enter a valid number.";

	Class<?>[] groups() default { };

	/**
	 * required fo hibernate validation
	 **/
	Class<? extends Payload>[] payload() default { };
}