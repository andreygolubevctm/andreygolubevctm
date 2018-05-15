package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;

/**
 * {@link AlwaysHeldContinuousCoverCalculator} implements the {@link LHCCalculationStrategy} and defines the algorithm
 * for calculating LHC percentage when an applicant has stated they have always held continuous cover.
 * <p>
 * This implementation always returns {@link Constants#MIN_LHC_PERCENTAGE}.
 *
 * @see LHCCalculationDetails#getContinuousCover()
 */
public class AlwaysHeldContinuousCoverCalculator implements LHCCalculationStrategy {

    AlwaysHeldContinuousCoverCalculator() { /* Intentionally Empty package private constructor. */ }

    @Override
    public long calculateLHCPercentage() {
        return Constants.MIN_LHC_PERCENTAGE;
    }
}
