package com.ctm.web.health.quote.model.response;

import java.math.BigDecimal;

public class Price extends PriceInfo {

    private BigDecimal lhc;

    private BigDecimal grossPremium;

    private BigDecimal loadingAmount;

    private DiscountedPrice discountedPrice;

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

    public BigDecimal getLoadingAmount() {
        return loadingAmount;
    }

    public void setLoadingAmount(BigDecimal loadingAmount) {
        this.loadingAmount = loadingAmount;
    }

    public DiscountedPrice getDiscountedPrice() {
        return discountedPrice;
    }

    public void setDiscountedPrice(DiscountedPrice discountedPrice) {
        this.discountedPrice = discountedPrice;
    }
}
