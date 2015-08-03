package com.ctm.model.creditcards;

import com.ctm.model.Product;

public class Features {

	private String additionalCardHolder;
	private boolean availableToTemporaryResidents;
	private boolean extendedWarranty;
	private String foreignExchangeFees;
	private String interestFreeDays;
	private Double latePaymentFee;
	private Double maximumCreditLimit;
	private Double minimumCreditLimit;
	private Double minimumIncome;
	private String minimumMonthlyRepayment;
	private boolean travelInsurance;

	public Features(){

	}

	public String getAdditionalCardHolder() {
		return additionalCardHolder;
	}

	public void setAdditionalCardHolder(String additionalCardHolder) {
		this.additionalCardHolder = additionalCardHolder;
	}

	public boolean isAvailableToTemporaryResidents() {
		return availableToTemporaryResidents;
	}

	public void setAvailableToTemporaryResidents(
			boolean availableToTemporaryResidents) {
		this.availableToTemporaryResidents = availableToTemporaryResidents;
	}

	public boolean isExtendedWarranty() {
		return extendedWarranty;
	}

	public void setExtendedWarranty(boolean extendedWarranty) {
		this.extendedWarranty = extendedWarranty;
	}

	public String getForeignExchangeFees() {
		return foreignExchangeFees;
	}

	public void setForeignExchangeFees(String foreignExchangeFees) {
		this.foreignExchangeFees = foreignExchangeFees;
	}

	public String getInterestFreeDays() {
		return interestFreeDays;
	}

	public void setInterestFreeDays(String interestFreeDays) {
		this.interestFreeDays = interestFreeDays;
	}

	public Double getLatePaymentFee() {
		return latePaymentFee;
	}

	public void setLatePaymentFee(Double latePaymentFee) {
		this.latePaymentFee = latePaymentFee;
	}

	public Double getMaximumCreditLimit() {
		return maximumCreditLimit;
	}

	public void setMaximumCreditLimit(Double maximumCreditLimit) {
		this.maximumCreditLimit = maximumCreditLimit;
	}

	public Double getMinimumCreditLimit() {
		return minimumCreditLimit;
	}

	public void setMinimumCreditLimit(Double minimumCreditLimit) {
		this.minimumCreditLimit = minimumCreditLimit;
	}

	public Double getMinimumIncome() {
		return minimumIncome;
	}

	public void setMinimumIncome(Double minimumIncome) {
		this.minimumIncome = minimumIncome;
	}

	public String getMinimumMonthlyRepayment() {
		return minimumMonthlyRepayment;
	}

	public void setMinimumMonthlyRepayment(String minimumMonthlyRepayment) {
		this.minimumMonthlyRepayment = minimumMonthlyRepayment;
	}

	public boolean isTravelInsurance() {
		return travelInsurance;
	}

	public void setTravelInsurance(boolean travelInsurance) {
		this.travelInsurance = travelInsurance;
	}

	public void importFromProduct(Product product){

		setAdditionalCardHolder(product.getPropertyAsString("additional-card-holder"));
		setAvailableToTemporaryResidents(product.getPropertyAsBoolean("available-temporary-residents"));
		setExtendedWarranty(product.getPropertyAsBoolean("extended-warranty"));
		setForeignExchangeFees(product.getPropertyAsString("foreign-exchange-fees"));
		setInterestFreeDays(product.getPropertyAsString("interest-free-days"));
		setLatePaymentFee(product.getPropertyAsDouble("late-payment-fee"));
		setMaximumCreditLimit(product.getPropertyAsDouble("maximum-credit-limit"));
		setMinimumCreditLimit(product.getPropertyAsDouble("minimum-credit-limit"));
		setMinimumIncome(product.getPropertyAsDouble("minimum-income"));
		setMinimumMonthlyRepayment(product.getPropertyAsString("minimum-monthly-repayment"));
		setTravelInsurance(product.getPropertyAsBoolean("complimentary-travel-insurance"));
	}

}
