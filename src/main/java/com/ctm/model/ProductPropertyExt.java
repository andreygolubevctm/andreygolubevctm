package com.ctm.model;

public class ProductPropertyExt {

	public static String TYPE_JSON = "J";
	public static String TYPE_XML = "X";

	private int productId;
	private String text;
	private String type;

	public ProductPropertyExt() {

	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}


}
