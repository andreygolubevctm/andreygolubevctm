package com.ctm.providers.travel.travelquote.model.response;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.apache.commons.lang3.StringUtils;

public class BenefitType {

    public static final String CXDFEE = "CXDFEE";
    public static final String EXCESS = "EXCESS";
    public static final String MEDICAL = "MEDICAL";
    public static final String LUGGAGE = "LUGGAGE";
    public static final String CUSTOM = "CUSTOM";

    private final String benefitName;

    public BenefitType(final String benefitName) {
        if (StringUtils.isBlank(benefitName)) {
            this.benefitName = CUSTOM;
        } else {
            this.benefitName = benefitName;
        }
    }

    public String getBenefitName() {
        return benefitName;
    }

    public boolean isCancellationFeeType() {
        return StringUtils.equals(benefitName, CXDFEE);
    }

    @JsonIgnore
    public boolean isExcessType() {
        return StringUtils.equals(benefitName, EXCESS);
    }

    @JsonIgnore
    public boolean isMedicalType() {
        return StringUtils.equals(benefitName, MEDICAL);
    }

    @JsonIgnore
    public boolean isLuggageType() {
        return StringUtils.equals(benefitName, LUGGAGE);
    }

    public static final BenefitType createCancellationFeeType() {
        return new BenefitType(CXDFEE);
    }

    public static final BenefitType createExcessType() {
        return new BenefitType(EXCESS);
    }

    public static final BenefitType createMedicalType() {
        return new BenefitType(MEDICAL);
    }

    public static final BenefitType createLuggageType() {
        return new BenefitType(LUGGAGE);
    }

    public static final BenefitType createCustomType() {
        return new BenefitType(CUSTOM);
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final BenefitType that = (BenefitType) o;

        return benefitName.equals(that.benefitName);

    }

    @Override
    public int hashCode() {
        return benefitName.hashCode();
    }
}
