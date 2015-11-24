package com.ctm.web.energy.form.response.model;


public class EnergyResultsPlanModel {

    private String available;
    private int planId;
    private String planName;
    private String retailerName;
    private String retailerId;
    double yearlySavings;
    private double price;
    private double previousPrice;
    private String contractPeriod;
    private String cancellationFees;

    double  estimatedCost;

    private String payontimeDiscounts;
    private String ebillingDiscounts;
    private String guaranteedDiscounts;
    private String otherDiscounts;
    private String discountDetails;

    public double getEstimatedCost() {
        return estimatedCost;
    }

    public void setEstimatedCost(double estimatedCost) {
        this.estimatedCost = estimatedCost;
    }


    public int getPlanId() {
        return planId;
    }

    public void setPlanId(int planId) {
        this.planId = planId;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    public String getRetailerName() {
        return retailerName;
    }

    public void setRetailerName(String retailerName) {
        this.retailerName = retailerName;
    }

    public String getRetailerId() {
        return retailerId;
    }

    public void setRetailerId(String retailerId) {
        this.retailerId = retailerId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getPreviousPrice() {
        return previousPrice;
    }

    public void setPreviousPrice(double previousPrice) {
        this.previousPrice = previousPrice;
    }

    public String getContractPeriod() {
        return contractPeriod;
    }

    public void setContractPeriod(String contractPeriod) {
        this.contractPeriod = contractPeriod;
    }

    public String getCancellationFees() {
        return cancellationFees;
    }

    public void setCancellationFees(String cancellationFees) {
        this.cancellationFees = cancellationFees;
    }

    public String getPayontimeDiscounts() {
        return payontimeDiscounts;
    }

    public void setPayontimeDiscounts(String payontimeDiscounts) {
        this.payontimeDiscounts = payontimeDiscounts;
    }

    public String getEbillingDiscounts() {
        return ebillingDiscounts;
    }

    public void setEbillingDiscounts(String ebillingDiscounts) {
        this.ebillingDiscounts = ebillingDiscounts;
    }

    public String getGuaranteedDiscounts() {
        return guaranteedDiscounts;
    }

    public void setGuaranteedDiscounts(String guaranteedDiscounts) {
        this.guaranteedDiscounts = guaranteedDiscounts;
    }

    public String getOtherDiscounts() {
        return otherDiscounts;
    }

    public void setOtherDiscounts(String otherDiscounts) {
        this.otherDiscounts = otherDiscounts;
    }

    public String getDiscountDetails() {
        return discountDetails;
    }

    public void setDiscountDetails(String discountDetails) {
        this.discountDetails = discountDetails;
    }

    public double getYearlySavings() {
        return yearlySavings;
    }

    public void setYearlySavings(double yearlySavings) {
        this.yearlySavings = yearlySavings;
    }

    @Override
    public String toString() {
        return "UtilitiesResultsPlanModel{" +
                "retailerId='" + retailerId + '\'' +
                ", retailerName='" + retailerName + '\'' +
                ", planId=" + planId +
                ", planName='" + planName + '\'' +
                ", price='" + price + '\'' +
                ", contractPeriod='" + contractPeriod + '\'' +
                ", cancellationFees='" + cancellationFees + '\'' +
                ", payontimeDiscounts='" + payontimeDiscounts + '\'' +
                ", ebillingDiscounts='" + ebillingDiscounts + '\'' +
                ", guaranteedDiscounts='" + guaranteedDiscounts + '\'' +
                ", otherDiscounts='" + otherDiscounts + '\'' +
                ", discountDetails='" + discountDetails + '\'' +
                ", contractPeriod=" + contractPeriod +
                ", cancellationFees=" + cancellationFees +
                ", payontimeDiscounts=" + payontimeDiscounts +
                ", ebillingDiscounts=" + ebillingDiscounts +
                ", guaranteedDiscounts=" + guaranteedDiscounts +
                ", otherDiscounts=" + otherDiscounts +
                ", discountDetails=" + discountDetails +
                ", yearlySavings=" + yearlySavings +
                '}';
    }

    public String getAvailable() {
        return available;
    }

    public void setAvailable(String available) {
        this.available = available;
    }
}
