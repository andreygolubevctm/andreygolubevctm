package com.ctm.web.core.model.constraints;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.TYPE, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = ProviderContentValidator.class)
@Documented
public @interface ValidProviderContent {
	String message () default "The content is invalid for this ProviderContent type.";
	Class<?>[] groups () default {};
	Class<? extends Payload>[] payload () default {};
}
