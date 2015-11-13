package com.ctm.web.core.validation;

import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.*;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

@Pattern(regexp = "^([a-zA-Z0-9])+$")
@Size(min = 40, max = 40)
@Target( { METHOD, FIELD, ANNOTATION_TYPE })
@Retention(RUNTIME)
@Constraint(validatedBy = {})
@Documented
public @interface FortyCharHash {
    String message() default "{com.ctm.web.core.validation.fortycharhash}";

    Class<?>[] groups() default { };

    Class<? extends Payload>[] payload() default { };
}