package com.ctm.energy.quote.request.model;


import java.math.BigDecimal;

public abstract class UsageDetails {

    private BigDecimal billAmount;
    private  Integer billDays;

    public UsageDetails(BigDecimal billAmount, Integer billDays) {
        this.billAmount = billAmount;
        this.billDays = billDays;
    }

    protected UsageDetails() {
    }


    public BigDecimal getBillAmount() {
        return billAmount;
    }

    public Integer getBillDays() {
        return billDays;
    }

}
