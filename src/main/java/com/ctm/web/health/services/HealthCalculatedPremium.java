package com.ctm.web.health.services;

public class HealthCalculatedPremium {

    private Double hospitalValue;
    private Double grossPremium;
    private Double paymentValue;
    private Double discountValue;
    private Double discountPercentage;
    private Double lhcValue;
    private Double rebateValue;
    private Integer periods;
    private Double abd;
    private Double abdValue;

    public HealthCalculatedPremium() {
    }

    public Double getAbd() {
        return abd;
    }

    public void setAbd(Double abd) {
        this.abd = abd;
    }

    public Double getAbdValue() {
        return abdValue;
    }

    public void setAbdValue(Double abdValue) {
        this.abdValue = abdValue;
    }

    public Double getHospitalValue() {
        return hospitalValue;
    }

    public void setHospitalValue(Double hospitalValue) {
        this.hospitalValue = hospitalValue;
    }

    public Double getGrossPremium() {
        return grossPremium;
    }

    public void setGrossPremium(Double grossPremium) {
        this.grossPremium = grossPremium;
    }

    public Double getPaymentValue() {
        return paymentValue;
    }

    public void setPaymentValue(Double paymentValue) {
        this.paymentValue = paymentValue;
    }

    public Double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(Double discountValue) {
        this.discountValue = discountValue;
    }

    public Double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(Double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public Double getRebateValue() {
        return rebateValue;
    }

    public void setRebateValue(Double rebateValue) {
        this.rebateValue = rebateValue;
    }

    public Double getLhcValue() {
        return lhcValue;
    }

    public void setLhcValue(Double lhcValue) {
        this.lhcValue = lhcValue;
    }


    public Integer getPeriods() {
        return periods;
    }

    public void setPeriods(Integer periods) {
        this.periods = periods;
    }
}
