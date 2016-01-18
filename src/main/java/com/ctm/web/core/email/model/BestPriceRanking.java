package com.ctm.web.core.email.model;

public class BestPriceRanking {

	private String smallLogo;
	private String premium;
	private String premiumText;
	private String providerName;
	private String productName;
	private String excess;
	private String url;

	public void setExcess(String excess) {
		this.excess = excess;
	}

	public void setSmallLogo(String smallLogo) {
		this.smallLogo = smallLogo;
	}

	public void setPremium(String premium) {
		this.premium = premium;
	}

	public void setPremiumText(String premiumText) {
		this.premiumText = premiumText;
	}

	public void setProviderName(String providerName) {
		this.providerName = providerName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public void setApplyUrl(String url) {
		this.url = url;
	}

	public String getExcess() {
		return excess;
	}

	public String getSmallLogo() {
		return smallLogo;
	}

	public String getPremium() {
		return premium;
	}

	public String getPremiumText() {
		return premiumText;
	}

	public String getProviderName() {
		return providerName;
	}

	public String getProductName() {
		return productName;
	}

	public String getApplyUrl() {
		return url;
	}
}
