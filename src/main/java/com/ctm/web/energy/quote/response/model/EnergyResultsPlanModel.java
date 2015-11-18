package com.ctm.web.energy.quote.response.model;

public class EnergyResultsPlanModel {

	private int productId;
	private String retailerId;
	private String retailerName;
	private String planName;
	private String offerType;
	private String contractPeriod;
	private String cancellationFees;

	private Discount discount;

	private Savings quarterlySavings;
	private Savings percentageSavings;
	private Savings yearlySavings;
	private Savings annualSavings;

	public String getRetailerId() {
		return retailerId;
	}

	public void setRetailerId(String retailerId) {
		this.retailerId = retailerId;
	}

	public String getRetailerName() {
		return retailerName;
	}

	public void setRetailerName(String retailerName) {
		this.retailerName = retailerName;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public String getOfferType() {
		return offerType;
	}

	public void setOfferType(String offerType) {
		this.offerType = offerType;
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


	public Discount getDiscount() {
		return discount;
	}

	public void setDiscount(Discount discount) {
		this.discount = discount;
	}

	public Savings getQuarterlySavings() {
		return quarterlySavings;
	}

	public void setQuarterlySavings(Savings quarterlySavings) {
		this.quarterlySavings = quarterlySavings;
	}

	public Savings getPercentageSavings() {
		return percentageSavings;
	}

	public void setPercentageSavings(Savings percentageSavings) {
		this.percentageSavings = percentageSavings;
	}

	public Savings getYearlySavings() {
		return yearlySavings;
	}

	public void setYearlySavings(Savings yearlySavings) {
		this.yearlySavings = yearlySavings;
	}

	public Savings getAnnualSavings() {
		return annualSavings;
	}

	public void setAnnualSavings(Savings annualSavings) {
		this.annualSavings = annualSavings;
	}
}
