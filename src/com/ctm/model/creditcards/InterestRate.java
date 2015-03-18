package com.ctm.model.creditcards;

import com.ctm.model.Product;

public class InterestRate {

	private Double percentage;
	private Double introductoryPercentage;
	private Double introductoryPeriodMonths;

	public InterestRate(){

	}

	public Double getPercentage() {
		return percentage;
	}

	public void setPercentage(Double percentage) {
		this.percentage = percentage;
	}

	public Double getIntroductoryPercentage() {
		return introductoryPercentage;
	}

	public void setIntroductoryFee(Double introductoryPercentage) {
		this.introductoryPercentage = introductoryPercentage;
	}

	public Double getIntroductoryPeriodMonths() {
		return introductoryPeriodMonths;
	}

	public void setIntroductoryPeriodMonths(Double introductoryPeriodMonths) {
		this.introductoryPeriodMonths = introductoryPeriodMonths;
	}

	public void importFromProduct(Product product) {
		setPercentage(product.getPropertyAsDouble("interest-rate"));
		setIntroductoryFee(product.getPropertyAsDouble("intro-rate"));
		setIntroductoryPeriodMonths(product.getPropertyAsDouble("intro-rate-period"));

	}

}
