package com.ctm.web.creditcards.model;

import com.ctm.web.core.model.Product;

public class Information {

	private String description;
	private String name;
	private Terms terms;

	public Information(){

	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Terms getTerms() {
		return terms;
	}

	public void setTerms(Terms terms) {
		this.terms = terms;
	}

	public void importFromProduct(Product product){

		setDescription(product.getPropertyAsString("product-desc"));
		setName(product.getLongTitle());

		Terms terms = new Terms();
		terms.importFromProduct(product);
		setTerms(terms);
	}

}
