package com.ctm.web.creditcards.model;

import com.ctm.model.Product;

public class CashAdvanceRate {

	Double percentage;

	public CashAdvanceRate(){

	}

	public Double getPercentage() {
		return percentage;
	}

	public void setPercentage(Double rate) {
		this.percentage = rate;
	}

	public void importFromProduct(Product product){

		setPercentage(product.getPropertyAsDouble("cash-advance-rate"));

	}


}
