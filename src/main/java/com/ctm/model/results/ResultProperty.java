package com.ctm.model.results;

public class ResultProperty {

	private Long transactionId;
	private String productId;
	private String property;
	private String value;

	public ResultProperty(){

	}

	public Long getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(Long transactionId) {
		this.transactionId = transactionId;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return "ResultProperty{" +
				"transactionId=" + transactionId +
				", productId='" + productId + '\'' +
				", property='" + property + '\'' +
				", value='" + value + '\'' +
				'}';
	}
}
