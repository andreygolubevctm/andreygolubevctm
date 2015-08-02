package com.ctm.model.creditcards;

import com.ctm.model.Product;

public class Terms {

	private String interestRate;
	private String rewards;
	private String balanceTransfer;
	private String otherFeatures;
	private String general;

	public Terms(){

	}


	public void importFromProduct(Product product){
		setInterestRate(product.getPropertyAsLongText("terms-interest-rate"));
		setRewards(product.getPropertyAsLongText("terms-rewards"));
		setBalanceTransfer(product.getPropertyAsLongText("terms-balance-transfer"));
		setOtherFeatures(product.getPropertyAsLongText("terms-other-features"));
		setGeneral(product.getPropertyAsLongText("terms-general"));
	}

	public String[] getInterestRate() {
		return interestRate == null ? null : interestRate.split("\n");
	}

	public void setInterestRate(String interestRate) {
		this.interestRate = interestRate;
	}

	public String[] getRewards() {
		return rewards == null ? null : rewards.split("\n");
	}

	public void setRewards(String rewards) {
		this.rewards = rewards;
	}

	public String[] getBalanceTransfer() {
		return balanceTransfer == null ? null : balanceTransfer.split("\n");
	}

	public void setBalanceTransfer(String balanceTransfer) {
		this.balanceTransfer = balanceTransfer;
	}

	public String[] getOtherFeatures() {
		return otherFeatures == null ? null : otherFeatures.split("\n");
	}

	public void setOtherFeatures(String otherFeatures) {
		this.otherFeatures = otherFeatures;
	}

	public String[] getGeneral() {
		return general == null ? null : general.split("\n");
	}

	public void setGeneral(String general) {
		this.general = general;
	}

}
