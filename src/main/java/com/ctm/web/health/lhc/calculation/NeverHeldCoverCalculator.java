package com.ctm.web.health.lhc.calculation;

import java.time.LocalDate;

import static com.ctm.web.health.lhc.calculation.Constants.MAX_LHC_PERCENTAGE;

/**
 * {@link NeverHeldCoverCalculator} implements the {@link LHCCalculationStrategy} and defines the algorithm
 * for calculating LHC percentage from an applicant's age when an applicant has never held cover.
 */
public class NeverHeldCoverCalculator implements LHCCalculationStrategy {

    private final long lhcAge;

    /**
     * Constructs an instance of {@link NeverHeldCoverCalculator} with the specified date of birth and calculation date.
     * <p>
     * NB: the applicant's LHC age is calculated from the date of birth on the most recent 1st JULY to {@code when}.
     *
     * @param dateOfBirth applicants date of birth.
     * @param when        when the LHC Calculation is being performed.
     * @see LHCDateCalculationSupport#getFinancialYearStart(LocalDate)
     */
    public NeverHeldCoverCalculator(LocalDate dateOfBirth, LocalDate when) {
        this.lhcAge = LHCDateCalculationSupport.calculateAgeInYearsFrom(dateOfBirth, LHCDateCalculationSupport.getFinancialYearStart(when));
    }

    @Override
    public long calculateLHCPercentage() {
        long lhcPercentage = Math.max(0, (lhcAge - Constants.LHC_REQUIREMENT_AGE) * 2);
        return Math.min(lhcPercentage, MAX_LHC_PERCENTAGE);
    }
}
