package com.ctm.web.health.lhc.model.validation;

import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.Optional;

public class LHCCoverBooleanValidator implements ConstraintValidator<IfContinuousCoverTrueNeverHadCoverMustBeFalse, LHCCalculationDetails> {

    public void initialize(IfContinuousCoverTrueNeverHadCoverMustBeFalse constraint) {
    }

    public boolean isValid(LHCCalculationDetails obj, ConstraintValidatorContext context) {
        Optional<Boolean> continuousCover = Optional.ofNullable(obj.getContinuousCover());
        if (!continuousCover.isPresent()) {
            return false;
        }
        Optional<Boolean> neverHadCover = Optional.ofNullable(obj.getNeverHadCover());
        if (!neverHadCover.isPresent()) {
            return false;
        }
        if (continuousCover.get()) {
            return !neverHadCover.get();
        } else {
            return true;
        }
    }
}
