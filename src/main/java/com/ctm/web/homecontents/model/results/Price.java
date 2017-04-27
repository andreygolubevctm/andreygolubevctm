package com.ctm.web.homecontents.model.results;

import java.math.BigDecimal;

public class Price {

    private BigDecimal annualPremium;

    private BigDecimal monthlyPremium;

    private BigDecimal monthlyFirstMonth;

    private BigDecimal annualisedMonthlyPremium;

    private boolean showMonthlyTotal;

    private boolean monthlyAvailable;

    private boolean annualAvailable;

    private String priceDisclaimer;

    public BigDecimal getAnnualPremium() {
        return annualPremium;
    }

    public void setAnnualPremium(BigDecimal annualPrice) {
        this.annualPremium = annualPrice;
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

    public boolean isShowMonthlyTotal() {
        return showMonthlyTotal;
    }

    public void setShowMonthlyTotal(final boolean showMonthlyTotal) {
        this.showMonthlyTotal = showMonthlyTotal;
    }

    public boolean isMonthlyAvailable() {
        return monthlyAvailable;
    }

    public void setMonthlyAvailable(final boolean monthlyAvailable) {
        this.monthlyAvailable = monthlyAvailable;
    }

    public boolean isAnnualAvailable() {
        return annualAvailable;
    }

    public void setAnnualAvailable(final boolean annualAvailable) {
        this.annualAvailable = annualAvailable;
    }

    public String getPriceDisclaimer() {
        return priceDisclaimer;
    }

    public void setPriceDisclaimer(final String priceDisclaimer) {
        this.priceDisclaimer = priceDisclaimer;
    }
}
