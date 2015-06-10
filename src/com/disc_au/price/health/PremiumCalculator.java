package com.disc_au.price.health;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class PremiumCalculator {

	private BigDecimal lhc;
	private BigDecimal loading;
	private String membership;
	private BigDecimal basePremium;
	private BigDecimal grossPremium;
	private BigDecimal rebate; // rebate after gov percentage, e.g. 29.04

	public void setRebate(double d) {
		if(d == 0) {
			this.rebate = new BigDecimal(100);
		} else {
			this.rebate = new BigDecimal(d);
		}
	}

	public double getLhc() {
		return lhc.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	}

	public void setLhc(String lhc) {
		if(lhc.isEmpty()) {
			this.lhc = new BigDecimal(0);
		} else {
			this.lhc = new BigDecimal(lhc);
		}

	}

	public void setLhc(double lhc) {
		this.lhc = new BigDecimal(lhc);
	}


	public void setBasePremium(String basePremium) {
		if(basePremium.isEmpty()) {
			this.basePremium = new BigDecimal(0);
		} else {
			this.basePremium = new BigDecimal(basePremium);
		}

	}

	public void setBasePremium(double basePremium) {
		this.basePremium = new BigDecimal(basePremium);
	}

	public double getGrossPremium() {
		return grossPremium.doubleValue();
	}

	public void setGrossPremium(String grossPremium) {
		if(grossPremium.isEmpty()) {
			this.grossPremium = new BigDecimal(0);
		} else {
			this.grossPremium = new BigDecimal(grossPremium);
		}

	}

	public void setGrossPremium(double grossPremium) {
		this.grossPremium = new BigDecimal(grossPremium);
	}

	public void setLoading(String loading) {
		if(loading.isEmpty()) {
			this.loading = new BigDecimal(0);
		} else {
			this.loading = new BigDecimal(loading);
		}
		this.loading = new BigDecimal(loading);
	}

	public void setMembership(String membership) {
		this.membership = membership;
	}

	public double getLoadingAmount() {
		return getLoadingAmountDecimal().doubleValue();
	}



	public BigDecimal getBaseAndLHC() {
		BigDecimal loadingAmount= getLoadingAmountDecimal();
		return loadingAmount.add(basePremium);
	}

	public BigDecimal getLoadingAmountDecimal() {
		if(lhc.equals(new BigDecimal(0)) || loading.equals(new BigDecimal(0))) {
			return new BigDecimal(0);
		} else if(membership.equals("F") || membership.equals("C")) {
			BigDecimal halfPremium = lhc.divide(new BigDecimal(2));
			BigDecimal precentageLoading = loading.divide(new BigDecimal(100));
			// Round to the nearest cent using half up
			BigDecimal individualLoading = halfPremium.multiply(precentageLoading).setScale(2, BigDecimal.ROUND_HALF_UP);
			BigDecimal calculatedPremium = individualLoading.multiply(new BigDecimal(2));
			return calculatedPremium;
		} else {
			BigDecimal precentageLoading = loading.divide(new BigDecimal(100));
			// Round to the nearest cent using half up
			BigDecimal calculatedPremium = lhc.multiply(precentageLoading).setScale(2, BigDecimal.ROUND_HALF_UP);
			return calculatedPremium;
		}
	}

	public BigDecimal getRebateAmountDecimal() {
		BigDecimal rebateAmount;
		if(rebate.doubleValue() != 100.0) {
			BigDecimal rebateCalcReal = rebate.divide(new BigDecimal(100));
			rebateAmount =  basePremium.multiply(rebateCalcReal).setScale(2, BigDecimal.ROUND_HALF_UP);
		}else{
			rebateAmount = new BigDecimal(0.0);
		}
		return rebateAmount;
	}

	public double getRebateAmount() {
		return getRebateAmountDecimal().doubleValue();
	}

	public BigDecimal getLHCFreeValueDecimal() {
		BigDecimal calculatedPremium;
		if(rebate.doubleValue() != 100.0) {
			//e.g. 0.7096 = (100 - 29.04) / 100
			BigDecimal rebateCalc = new BigDecimal(100).subtract(rebate).divide(new BigDecimal(100));
			calculatedPremium = basePremium.multiply(rebateCalc).setScale(2, BigDecimal.ROUND_HALF_UP);
		} else {
			calculatedPremium = basePremium;
		}
		return calculatedPremium;
	}

	public double getPremiumWithoutRebate(double price) {
		double premium = price;
		if(rebate.doubleValue() != 100.0 && price > 0) {
			//e.g. 0.7096 = (100 - 29.04) / 100
			BigDecimal rebateCalc = new BigDecimal(100).subtract(rebate).divide(new BigDecimal(100));
			premium = new BigDecimal(price).divide(rebateCalc, 2, RoundingMode.HALF_UP).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		return premium;
	}

	public BigDecimal getPremiumWithRebateAndLHCDecimal() {
		BigDecimal calculatedLhc = getLoadingAmountDecimal();
		BigDecimal calculatedPremiumWithRebate =getLHCFreeValueDecimal();
		return calculatedPremiumWithRebate.add(calculatedLhc).setScale(2, BigDecimal.ROUND_HALF_UP);
	}

	public double getPremiumWithRebateAndLHC() {
		return getPremiumWithRebateAndLHCDecimal().doubleValue();
	}


	public double getDiscountValue() {
		return grossPremium.subtract(basePremium).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	}

	public double getDiscountPercentage() {
		if (grossPremium.doubleValue() == 0.0){
			return 0.0;
		}else{
			return new BigDecimal(getDiscountValue()).divide(grossPremium, 2, RoundingMode.HALF_UP).multiply(new BigDecimal(100)).doubleValue();
		}
	}
}
