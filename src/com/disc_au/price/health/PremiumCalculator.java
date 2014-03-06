package com.disc_au.price.health;

import java.math.BigDecimal;

public class PremiumCalculator {

	private BigDecimal lhc;
	private BigDecimal loading;
	private String membership;

	public void setLhc(String lhc) {
		if(lhc.isEmpty()) {
			this.lhc = new BigDecimal(0);
		} else {
			this.lhc = new BigDecimal(lhc);
		}

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
		String loadingAmount = "";
		if(lhc.equals(new BigDecimal(0)) || loading.equals(new BigDecimal(0))) {
			loadingAmount = "0";
		} else if(membership.equals("F") || membership.equals("C")) {
			BigDecimal halfPremium = lhc.divide(new BigDecimal(2));
			BigDecimal precentageLoading = loading.divide(new BigDecimal(100));
			// Round to the nearest cent using half up
			BigDecimal individualLoading = halfPremium.multiply(precentageLoading).setScale(2, BigDecimal.ROUND_HALF_UP);
			BigDecimal calculatedPremium = individualLoading.multiply(new BigDecimal(2));
			loadingAmount = calculatedPremium.toString();
		} else {
			BigDecimal precentageLoading = loading.divide(new BigDecimal(100));
			// Round to the nearest cent using half up
			BigDecimal calculatedPremium = lhc.multiply(precentageLoading).setScale(2, BigDecimal.ROUND_HALF_UP);
			loadingAmount = calculatedPremium.toString();
		}
		return loadingAmount;
	}

}
