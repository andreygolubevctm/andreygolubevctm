package com.ctm.model;

import com.ctm.web.creditcards.category.model.Category;

public class CategoryProductMapping {

	private Product product;
	private Category category;

	public CategoryProductMapping(){

	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}



}
