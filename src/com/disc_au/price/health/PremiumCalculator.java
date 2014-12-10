package com.disc_au.price.health;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class PremiumCalculator {

	private BigDecimal lhc;
	private BigDecimal loading;
	private String membership;
	private BigDecimal basePremium;
	private BigDecimal rebateCalc;

	public void setRebateCalc(double d) {
		if(d == 0) {
			this.rebateCalc = new BigDecimal(1);
		} else {
			this.rebateCalc = new BigDecimal(d);
		}
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

	public String getLoadingAmount() {
		BigDecimal loadingAmount = getLoadingAmountDecimal();
		return loadingAmount.toString();
	}

	public String getBaseAndLHC() {
		BigDecimal loadingAmount= getLoadingAmountDecimal();
		return loadingAmount.add(basePremium).toString();
	}

	private BigDecimal getLoadingAmountDecimal() {
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

	public String getLHCFreeValue() {
		return getLHCFreeValueDecimal().toString();
	}

	public BigDecimal getLHCFreeValueDecimal() {
		BigDecimal calculatedPremium;
		if(rebateCalc.doubleValue() != 1.0) {
			BigDecimal rebate = new BigDecimal(1).subtract(rebateCalc);
			calculatedPremium = basePremium.multiply(rebate).setScale(2, BigDecimal.ROUND_HALF_UP);
		} else {
			calculatedPremium = basePremium;
		}
		return calculatedPremium;
	}

	public double getPremiumWithoutRebate(double price) {
		double premium = price;
		if(rebateCalc.doubleValue() != 1.0 && price > 0) {
			BigDecimal rebate = new BigDecimal(1).subtract(rebateCalc);
			premium = new BigDecimal(price).divide(rebate, 2, RoundingMode.HALF_UP).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		return premium;
	}
	
	public double getPremiumWithRebateAndLHC() {
		BigDecimal calculatedLhc = getLoadingAmountDecimal();
		BigDecimal calculatedPremiumWithRebate =getLHCFreeValueDecimal();
		return calculatedPremiumWithRebate.add(calculatedLhc).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	}

}
