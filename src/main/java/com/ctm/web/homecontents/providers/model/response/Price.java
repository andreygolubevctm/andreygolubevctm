package com.ctm.web.homecontents.providers.model.response;

import java.math.BigDecimal;

public class Price {

    private BigDecimal annualPremium;

    private BigDecimal monthlyPremium;

    private BigDecimal monthlyFirstMonth;

    private BigDecimal annualisedMonthlyPremium;

    public BigDecimal getAnnualPremium() {
        return annualPremium;
    }

    public void setAnnualPremium(BigDecimal annualPremium) {
        this.annualPremium = annualPremium;
    }

    public BigDecimal getMonthlyPremium() {
        return monthlyPremium;
    }

    public void setMonthlyPremium(BigDecimal monthlyPremium) {
        this.monthlyPremium = monthlyPremium;
    }

    public BigDecimal getMonthlyFirstMonth() {
        return monthlyFirstMonth;
    }

    public void setMonthlyFirstMonth(BigDecimal monthlyFirstMonth) {
        this.monthlyFirstMonth = monthlyFirstMonth;
    }

    public BigDecimal getAnnualisedMonthlyPremium() {
        return annualisedMonthlyPremium;
    }

    public void setAnnualisedMonthlyPremium(BigDecimal annualisedMonthlyPremium) {
        this.annualisedMonthlyPremium = annualisedMonthlyPremium;
    }
}
