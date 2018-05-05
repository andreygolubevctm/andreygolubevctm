package com.ctm.web.health.lhc.model.validation;

import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class LHCCoverBooleanValidator implements ConstraintValidator<IfContinuousCoverTrueNeverHadCoverMustBeFalse, LHCCalculationDetails> {

    public void initialize(IfContinuousCoverTrueNeverHadCoverMustBeFalse constraint) {
    }

    public boolean isValid(LHCCalculationDetails obj, ConstraintValidatorContext context) {
        if (obj.isContinuousCover()) {
            return !obj.isNeverHadCover();
        } else {
            return true;
        }
    }
}
