package com.ctm.web.health.lhc.calculation;

import java.time.LocalDate;

import static com.ctm.web.health.lhc.calculation.Constants.MAX_LHC_PERCENTAGE;

/**
 * {@link NeverHeldCoverCalculator} implements the {@link LHCCalculationStrategy} and defines the algorithm
 * for calculating LHC percentage from an applicant's age when an applicant has never held cover.
 */
public class NeverHeldCoverCalculator implements LHCCalculationStrategy {

    private final long ageAtStartOfFinYear;

    /**
     * Constructs an instance of {@link NeverHeldCoverCalculator} with the specified date of birth and calculation date.
     * <p>
     * NB: The applicant's LHC age is calculated from their age at the start of the financial year.
     *
     * @param dateOfBirth applicants date of birth.
     * @param when        when the LHC Calculation is being performed.
     * @see LHCDateCalculationSupport#getFinancialYearStart(LocalDate)
     */
    public NeverHeldCoverCalculator(LocalDate dateOfBirth, LocalDate when) {
        this.ageAtStartOfFinYear = LHCDateCalculationSupport.calculateAgeInYearsFrom(dateOfBirth, LHCDateCalculationSupport.getFinancialYearStart(when));
    }

    @Override
    public long calculateLHCPercentage() {
        long lhcPercentage = Math.max(0, (ageAtStartOfFinYear - Constants.LHC_REQUIREMENT_AGE) * 2);
        return Math.min(lhcPercentage, MAX_LHC_PERCENTAGE);
    }
}
