package com.ctm.web.health.lhc.calculation;

import java.time.LocalDate;

import static com.ctm.web.health.lhc.calculation.Constants.MAX_LHC_PERCENTAGE;

/**
 * {@link NeverHeldCoverCalculator} implements the {@link LHCCalculationStrategy} and defines the algorithm
 * for calculating LHC percentage from an applicant's age when an applicant has never held cover.
 */
public class NeverHeldCoverCalculator implements LHCCalculationStrategy {

    private final long applicantAgeAtBeginningOfFinYear;

    /**
     * Constructs an instance of {@link NeverHeldCoverCalculator} with the specified applicantAgeAtBeginningOfFinancialYear.
     *
     * @param applicantAgeAtBeginningOfFinancialYear the age of the applicant - cannot be less than zero.
     * @throws IllegalArgumentException if applicantAgeAtBeginningOfFinancialYear is less than zero.
     */
    public NeverHeldCoverCalculator(long applicantAgeAtBeginningOfFinancialYear) {
        if (applicantAgeAtBeginningOfFinancialYear < 0) {
            throw new IllegalArgumentException("applicant age cannot be less than zero");
        }
        this.applicantAgeAtBeginningOfFinYear = applicantAgeAtBeginningOfFinancialYear;
    }

    /**
     * Constructs an instance of {@link NeverHeldCoverCalculator} with the specified applicantAgeAtBeginningOfFinancialYear.
     *
     * @param dateOfBirth applicants date of birth.
     */
    public NeverHeldCoverCalculator(LocalDate dateOfBirth, LocalDate now) {
        this.applicantAgeAtBeginningOfFinYear = LHCDateCalculationSupport.calculateAgeInYearsFrom(dateOfBirth, LHCDateCalculationSupport.getFinancialYearStart(now));
    }

    @Override
    public long calculateLHCPercentage() {
        long lhcPercentage = Math.max(0, (applicantAgeAtBeginningOfFinYear - Constants.LHC_REQUIREMENT_AGE) * 2);
        return Math.min(lhcPercentage, MAX_LHC_PERCENTAGE);
    }
}
