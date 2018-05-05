package com.ctm.web.health.lhc.calculation;

import static com.ctm.web.health.lhc.calculation.Constants.MAX_LHC_PERCENTAGE;

/**
 * {@link NeverHeldCoverCalculator} implements the {@link LHCCalculationStrategy} and defines the algorithm
 * for calculating LHC percentage from an applicant's age when an applicant has never held cover.
 */
public class NeverHeldCoverCalculator implements LHCCalculationStrategy {

    private final long applicantAge;

    /**
     * Constructs an instance of {@link NeverHeldCoverCalculator} with the specified applicantAge.
     *
     * @param applicantAge the age of the applicant - cannot be less than zero.
     * @throws IllegalArgumentException if applicantAge is less than zero.
     */
    public NeverHeldCoverCalculator(long applicantAge) {
        if (applicantAge < 0) {
            throw new IllegalArgumentException("applicant age cannot be less than zero");
        }
        this.applicantAge = applicantAge;
    }

    @Override
    public int calculateLHCPercentage() {
        long lhcPercentage = Math.max(0, (applicantAge - Constants.LHC_REQUIREMENT_AGE) * 2);
        return Long.valueOf(Math.min(lhcPercentage, MAX_LHC_PERCENTAGE)).intValue();
    }
}
