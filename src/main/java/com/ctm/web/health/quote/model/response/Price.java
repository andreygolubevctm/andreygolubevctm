package com.ctm.web.health.quote.model.response;

import java.math.BigDecimal;

public class Price {

    private BigDecimal grossPremium;

    private BigDecimal hospitalValue;

    private BigDecimal discountAmount;

    private BigDecimal discountPercentage;

    private BigDecimal rebateAmount;

    private BigDecimal rebatePercentage;

    private BigDecimal lhcAmount;

    private Integer lhcPercentage;

    private BigDecimal basePremium;

    private BigDecimal lhcFreeAmount;

    private BigDecimal baseAndLHC;

    private BigDecimal payableAmount;

    private Integer abd;
    private BigDecimal abdValue;

    private Price() {
    }

    private Price(BigDecimal grossPremium,
                 BigDecimal hospitalValue,
                 BigDecimal discountAmount,
                 BigDecimal discountPercentage,
                 BigDecimal rebateAmount,
                 BigDecimal rebatePercentage,
                 BigDecimal lhcAmount,
                 Integer lhcPercentage,
                 BigDecimal basePremium,
                 BigDecimal lhcFreeAmount,
                 BigDecimal baseAndLHC,
                 BigDecimal payableAmount,
                  Integer abdPercentage,
                  BigDecimal abdAmount) {
        this.grossPremium = grossPremium;
        this.hospitalValue = hospitalValue;
        this.discountAmount = discountAmount;
        this.discountPercentage = discountPercentage;
        this.rebateAmount = rebateAmount;
        this.rebatePercentage = rebatePercentage;
        this.lhcAmount = lhcAmount;
        this.lhcPercentage = lhcPercentage;
        this.basePremium = basePremium;
        this.lhcFreeAmount = lhcFreeAmount;
        this.baseAndLHC = baseAndLHC;
        this.payableAmount = payableAmount;
        this.abd = abdPercentage;
        this.abdValue = abdAmount;
    }

    public static final Price DEFAULT_PRICE = new Price(
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            0,
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            0,
            BigDecimal.ZERO);

    public BigDecimal getGrossPremium() {
        return grossPremium;
    }

    public BigDecimal getHospitalValue() {
        return hospitalValue;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public BigDecimal getDiscountPercentage() {
        return discountPercentage;
    }

    public BigDecimal getRebateAmount() {
        return rebateAmount;
    }

    public BigDecimal getRebatePercentage() {
        return rebatePercentage;
    }

    public BigDecimal getLhcAmount() {
        return lhcAmount;
    }

    public Integer getLhcPercentage() {
        return lhcPercentage;
    }

    public BigDecimal getBasePremium() {
        return basePremium;
    }

    public BigDecimal getLhcFreeAmount() {
        return lhcFreeAmount;
    }

    public BigDecimal getBaseAndLHC() {
        return baseAndLHC;
    }

    public BigDecimal getPayableAmount() {
        return payableAmount;
    }

    public Integer getAbd() {
        return abd;
    }

    public BigDecimal getAbdValue() {
        return abdValue;
    }
}
