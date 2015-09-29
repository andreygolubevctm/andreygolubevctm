package com.ctm.providers.health.healthquote.model.response;

import java.math.BigDecimal;

public class DiscountedPrice extends PriceInfo {

    private BigDecimal discountedPremium;

    private BigDecimal discountPercentage;

    private BigDecimal discountAmount;

    public BigDecimal getDiscountedPremium() {
        return discountedPremium;
    }

    public void setDiscountedPremium(BigDecimal discountedPremium) {
        this.discountedPremium = discountedPremium;
    }

    public BigDecimal getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(BigDecimal discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
}
