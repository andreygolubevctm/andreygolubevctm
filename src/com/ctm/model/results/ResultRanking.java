package com.ctm.model.results;

public class ResultRanking {

	private Long transactionId;
	private int rankPosition;
	private String productId;

	public ResultRanking(){

	}

	public Long getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(Long transactionId) {
		this.transactionId = transactionId;
	}

	public int getRankPosition() {
		return rankPosition;
	}

	public void setRankPosition(int rankPosition) {
		this.rankPosition = rankPosition;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}
}
