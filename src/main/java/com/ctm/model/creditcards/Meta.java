package com.ctm.model.creditcards;

import com.ctm.model.Product;

public class Meta {

	private String description;
	private String title;

	public Meta(){

	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void importFromProduct(Product product){

		setTitle(product.getPropertyAsString("meta-page-title"));
		setDescription(product.getPropertyAsString("meta-page-desc"));

	}

}
