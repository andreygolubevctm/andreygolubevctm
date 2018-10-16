package com.ctm.web.health.lhc.calculation;

import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;

/**
 * {@link MinimumLHCCalculationStrategy} implements the {@link LHCCalculationStrategy} and defines the algorithm
 * for returning the minimum applicable LHC percentage when an applicant:
 * <ul>
 *     <li>has stated they have always held continuous cover</li>
 *     <li>has no applicable LHC cover days (i.e. aged less than 30 - {@link Constants#LHC_REQUIREMENT_AGE})</li>
 *     <li>was born prior to the 1st June 1934 - {@link Constants#LHC_BIRTHDAY_APPLICABILITY_DATE}</li>
 * </ul>
 * <p>
 * This implementation always returns {@link Constants#MIN_LHC_PERCENTAGE}.
 *
 * @see LHCCalculationDetails#getContinuousCover()
 * @see Constants#LHC_REQUIREMENT_AGE
 * @see Constants#LHC_BIRTHDAY_APPLICABILITY_DATE
 */
public class MinimumLHCCalculationStrategy implements LHCCalculationStrategy {

    MinimumLHCCalculationStrategy() { /* Intentionally Empty package private constructor. */ }

    @Override
    public long calculateLHCPercentage() {
        return Constants.MIN_LHC_PERCENTAGE;
    }
}
