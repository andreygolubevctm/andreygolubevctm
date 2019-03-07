package com.ctm.web.health.quote.model.request;

import java.time.LocalDate;

public class AbdDetails {
    private LocalDate dateOfBirth;
    private LocalDate assessmentDate;
    private int ageBasedDiscountPercentage;
    private int retainedAgeBasedDiscountPercentage;
    private int certifiedDiscountAge;
    private int currentAge;

    public AbdDetails() {
    }

    public AbdDetails(LocalDate dateOfBirth, LocalDate assessmentDate, int ageBasedDiscountPercentage, int retainedAgeBasedDiscountPercentage, int certifiedDiscountAge, int currentAge) {
        this.dateOfBirth = dateOfBirth;
        this.assessmentDate = assessmentDate;
        this.ageBasedDiscountPercentage = ageBasedDiscountPercentage;
        this.retainedAgeBasedDiscountPercentage = retainedAgeBasedDiscountPercentage;
        this.certifiedDiscountAge = certifiedDiscountAge;
        this.currentAge = currentAge;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public LocalDate getAssessmentDate() {
        return assessmentDate;
    }

    public void setAssessmentDate(LocalDate assessmentDate) {
        this.assessmentDate = assessmentDate;
    }

    public int getAgeBasedDiscountPercentage() {
        return ageBasedDiscountPercentage;
    }

    public void setAgeBasedDiscountPercentage(int ageBasedDiscountPercentage) {
        this.ageBasedDiscountPercentage = ageBasedDiscountPercentage;
    }

    public int getRetainedAgeBasedDiscountPercentage() {
        return retainedAgeBasedDiscountPercentage;
    }

    public void setRetainedAgeBasedDiscountPercentage(int retainedAgeBasedDiscountPercentage) {
        this.retainedAgeBasedDiscountPercentage = retainedAgeBasedDiscountPercentage;
    }

    public int getCertifiedDiscountAge() {
        return certifiedDiscountAge;
    }

    public void setCertifiedDiscountAge(int certifiedDiscountAge) {
        this.certifiedDiscountAge = certifiedDiscountAge;
    }

    public int getCurrentAge() {
        return currentAge;
    }

    public void setCurrentAge(int currentAge) {
        this.currentAge = currentAge;
    }
}
