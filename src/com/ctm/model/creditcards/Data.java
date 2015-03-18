package com.ctm.model.creditcards;

import com.ctm.model.Product;

public class Data {

	private AnnualFee annualFee;
	private BalanceTransferRate balanceTransferRate;
	private CashAdvanceRate cashAdvanceRate;
	private InterestRate interestRate;
	private Rewards rewards;

	public Data(){

	}

	public AnnualFee getAnnualFee() {
		return annualFee;
	}

	public void setAnnualFee(AnnualFee annualFee) {
		this.annualFee = annualFee;
	}

	public BalanceTransferRate getBalanceTransferRate() {
		return balanceTransferRate;
	}

	public void setBalanceTransferRate(BalanceTransferRate balanceTransferRate) {
		this.balanceTransferRate = balanceTransferRate;
	}

	public CashAdvanceRate getCashAdvanceRate() {
		return cashAdvanceRate;
	}

	public void setCashAdvanceRate(CashAdvanceRate cashAdvanceRate) {
		this.cashAdvanceRate = cashAdvanceRate;
	}

	public InterestRate getInterestRate() {
		return interestRate;
	}

	public void setInterestRate(InterestRate interestRate) {
		this.interestRate = interestRate;
	}

	public Rewards getRewards() {
		return rewards;
	}

	public void setRewards(Rewards rewards) {
		this.rewards = rewards;
	}

	public void importFromProduct(Product product){

		AnnualFee annualFee = new AnnualFee();
		annualFee.importFromProduct(product);
		setAnnualFee(annualFee);

		BalanceTransferRate balanceTransferRate = new BalanceTransferRate();
		balanceTransferRate.importFromProduct(product);
		setBalanceTransferRate(balanceTransferRate);

		CashAdvanceRate cashAdvanceRate = new CashAdvanceRate();
		cashAdvanceRate.importFromProduct(product);
		setCashAdvanceRate(cashAdvanceRate);

		InterestRate interestRate = new InterestRate();
		interestRate.importFromProduct(product);
		setInterestRate(interestRate);

		Rewards rewards = new Rewards();
		rewards.importFromProduct(product);
		setRewards(rewards);
	}

}
