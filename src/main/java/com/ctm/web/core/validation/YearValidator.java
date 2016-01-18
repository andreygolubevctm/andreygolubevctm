package com.ctm.web.core.validation;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.Calendar;

public class YearValidator implements ConstraintValidator<Year, Integer> {
    private boolean allowFuture;

    @Override
    public void initialize(final Year constraintAnnotation) {
        allowFuture = constraintAnnotation.allowFuture();
    }

    @Override
    public boolean isValid(final Integer value, final ConstraintValidatorContext context) {
        try {
            if(!allowFuture) {
                int currentYear = Calendar.getInstance().get(Calendar.YEAR);
                return value.intValue() <= currentYear;
            }
        } catch (final Exception ignore) {
            // ignore
        }
        return true;
    }
}