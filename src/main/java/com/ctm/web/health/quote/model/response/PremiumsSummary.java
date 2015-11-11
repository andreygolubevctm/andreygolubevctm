package com.ctm.web.health.quote.model.response;

public class PremiumsSummary {

    private PremiumRange yearlyPremiumRange;

    private PremiumRange monthlyPremiumRange;

    private PremiumRange fortnightlyPremiumRange;

    private String service;

    private String productId;

    public PremiumRange getYearlyPremiumRange() {
        return yearlyPremiumRange;
    }

    public void setYearlyPremiumRange(PremiumRange yearlyPremiumRange) {
        this.yearlyPremiumRange = yearlyPremiumRange;
    }

    public PremiumRange getMonthlyPremiumRange() {
        return monthlyPremiumRange;
    }

    public void setMonthlyPremiumRange(PremiumRange monthlyPremiumRange) {
        this.monthlyPremiumRange = monthlyPremiumRange;
    }

    public PremiumRange getFortnightlyPremiumRange() {
        return fortnightlyPremiumRange;
    }

    public void setFortnightlyPremiumRange(PremiumRange fortnightlyPremiumRange) {
        this.fortnightlyPremiumRange = fortnightlyPremiumRange;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }
}
