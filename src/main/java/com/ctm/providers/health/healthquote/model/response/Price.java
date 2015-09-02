package com.ctm.providers.health.healthquote.model.response;

import java.math.BigDecimal;

public class Price {

    private BigDecimal discountedPremium;

    private BigDecimal lhc;

    private BigDecimal grossPremium;

    public BigDecimal getLhc() {
        return lhc;
    }

    public void setLhc(BigDecimal lhc) {
        this.lhc = lhc;
    }

    public BigDecimal getGrossPremium() {
        return grossPremium;
    }

    public void setGrossPremium(BigDecimal grossPremium) {
        this.grossPremium = grossPremium;
    }

    public BigDecimal getDiscountedPremium() {
        return discountedPremium;
    }

    public void setDiscountedPremium(BigDecimal discountedPremium) {
        this.discountedPremium = discountedPremium;
    }
}
