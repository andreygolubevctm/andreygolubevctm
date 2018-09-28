package com.ctm.web.health.lhc.model.validation;

import com.ctm.web.health.lhc.model.query.CoverDateRange;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.time.LocalDate;
import java.util.Optional;

public class ToDateMustBeAfterFromDateValidator implements ConstraintValidator<ToDateIsEqualOrAfterFromDate, CoverDateRange> {

    public void initialize(ToDateIsEqualOrAfterFromDate constraint) {
    }

    public boolean isValid(CoverDateRange obj, ConstraintValidatorContext context) {
        Optional<LocalDate> rangeStart = Optional.ofNullable(obj.getFrom());
        Optional<LocalDate> rangeEnd = Optional.ofNullable(obj.getTo());

        if (rangeStart.isPresent() && rangeEnd.isPresent()) {
            return rangeStart.get().isBefore(rangeEnd.get().plusDays(1));
        } else {
            return true;
        }
    }
}
