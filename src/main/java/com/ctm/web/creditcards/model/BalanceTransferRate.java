package com.ctm.web.creditcards.model;

import com.ctm.web.core.model.Product;

public class BalanceTransferRate {

	private Double percentage;
	private Double introductoryPercentage;
	private Double introductoryPeriodMonths;
	private Double fee;

	public BalanceTransferRate(){

	}

	public Double getPercentage() {
		return percentage;
	}

	public void setPercentage(Double rate) {
		this.percentage = rate;
	}

	public Double getIntroductoryPercentage() {
		return introductoryPercentage;
	}

	public void setIntroductoryPercentage(Double introductoryPercentage) {
		this.introductoryPercentage = introductoryPercentage;
	}

	public Double getIntroductoryPeriodMonths() {
		return introductoryPeriodMonths;
	}

	public void setIntroductoryPeriodMonths(Double introductoryPeriodMonths) {
		this.introductoryPeriodMonths = introductoryPeriodMonths;
	}

	public void importFromProduct(Product product){

		setPercentage(product.getPropertyAsDouble("balance-transfer-rate"));
		setIntroductoryPercentage(product.getPropertyAsDouble("intro-balance-transfer-rate"));
		setIntroductoryPeriodMonths(product.getPropertyAsDouble("intro-balance-transfer-rate-period"));
		setFee(product.getPropertyAsDouble("balance-transfer-fee"));

	}

	public Double getFee() {
		return fee;
	}

	public void setFee(Double fee) {
		this.fee = fee;
	}
}
