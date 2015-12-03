package com.ctm.web.energy.form.response.model;


public class EnergyResultsPlanModel {

    private String available;
    private String planId;
    private String planName;
    private String retailerName;
    private String retailerId;
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

    private double estimatedElectricityCost;
    private double estimatedGasCost;
    private double yearlyElectricitySavings;
    private double yearlyGasSavings;

    public double getEstimatedElectricityCost() {
        return estimatedElectricityCost;
    }

    public void setEstimatedElectricityCost(double estimatedElectricityCost) {
        this.estimatedElectricityCost = estimatedElectricityCost;
    }

    public double getEstimatedGasCost() {
        return estimatedGasCost;
    }

    public void setEstimatedGasCost(double estimatedGasCost) {
        this.estimatedGasCost = estimatedGasCost;
    }

    public double getYearlyElectricitySavings() {
        return yearlyElectricitySavings;
    }

    public void setYearlyElectricitySavings(double yearlyElectricitySavings) {
        this.yearlyElectricitySavings = yearlyElectricitySavings;
    }

    public double getYearlyGasSavings() {
        return yearlyGasSavings;
    }

    public void setYearlyGasSavings(double yearlyGasSavings) {
        this.yearlyGasSavings = yearlyGasSavings;
    }

    public double getEstimatedCost() {
        return estimatedCost;
    }

    public void setEstimatedCost(double estimatedCost) {
        this.estimatedCost = estimatedCost;
    }


    public String getPlanId() {
        return planId;
    }

    public void setPlanId(String planId) {
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
                ", estimatedElectricityCost=" + estimatedElectricityCost +
                ", estimatedGasCost=" + estimatedGasCost +
                ", yearlyElectricitySavings=" + yearlyElectricitySavings +
                ", yearlyGasSavings=" + yearlyGasSavings +
                '}';
    }

    public String getAvailable() {
        return available;
    }

    public void setAvailable(String available) {
        this.available = available;
    }
}
