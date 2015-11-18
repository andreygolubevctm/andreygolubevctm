package com.ctm.web.creditcards.model;

import com.ctm.web.core.model.Product;

public class AnnualFee {

	private Double fee;
	private Double introductoryFee;
	private Double introductoryPeriodMonths;

	public AnnualFee(){

	}

	public Double getFee() {
		return fee;
	}

	public void setFee(Double fee) {
		this.fee = fee;
	}

	public Double getIntroductoryFee() {
		return introductoryFee;
	}

	public void setIntroductoryFee(Double introductoryFee) {
		this.introductoryFee = introductoryFee;
	}

	public Double getIntroductoryPeriodMonths() {
		return introductoryPeriodMonths;
	}

	public void setIntroductoryPeriodMonths(Double introductoryPeriodMonths) {
		this.introductoryPeriodMonths = introductoryPeriodMonths;
	}

	public void importFromProduct(Product product){

		setFee(product.getPropertyAsDouble("annual-fee"));
		setIntroductoryFee(product.getPropertyAsDouble("intro-annual-fee"));
		setIntroductoryPeriodMonths(product.getPropertyAsDouble("intro-annual-fee-period"));

	}

}
