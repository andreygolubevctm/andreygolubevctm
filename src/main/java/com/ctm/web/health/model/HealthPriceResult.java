package com.ctm.web.health.model;

public class HealthPriceResult {

	private String productId;
	private String longTitle;
	private String shortTitle;
	private int providerId;
	private String productCat;
	private String productCode;
	private int excessAmount;
	private int rank;
	private boolean isValid = true; // default as valid, only invalid if retrieve a saved quote has expired (not available) product

	private HealthPricePremium healthPricePremium = new HealthPricePremium();
	private HealthPricePremium altHealthPricePremium = new HealthPricePremium();

	private boolean isDiscountRates = false;
	private String productUpi;
	private String fundCode;
	private String fundName;
	private String extrasName;
	private String hospitalName;
	private String phioData;

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getLongTitle() {
		return longTitle;
	}

	public void setLongTitle(String longTitle) {
		this.longTitle = longTitle;
	}

	public String getShortTitle() {
		return shortTitle;
	}

	public void setShortTitle(String shortTitle) {
		this.shortTitle = shortTitle;
	}

	public int getProviderId() {
		return providerId;
	}

	public void setProviderId(int providerId) {
		this.providerId = providerId;
	}

	public String getProductCat() {
		return productCat;
	}

	public void setProductCat(String productCat) {
		this.productCat = productCat;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public int getExcessAmount() {
		return excessAmount;
	}

	public void setExcessAmount(int excessAmount) {
		this.excessAmount = excessAmount;
	}

	public int getRank() {
		return rank;
	}

	public void setRank(int rank) {
		this.rank = rank;
	}

	public boolean isValid() {
		return isValid;
	}

	public void setValid(boolean isValid) {
		this.isValid = isValid;
	}

	public boolean isDiscountRates() {
		return isDiscountRates;
	}

	public void setDiscountRates(boolean isDiscountRates) {
		this.isDiscountRates = isDiscountRates;
	}

	public HealthPricePremium getHealthPricePremium() {
		return healthPricePremium;
	}

	public HealthPricePremium getAltHealthPricePremium() {
		return altHealthPricePremium;
	}

	public String getProductUpi() {
		return productUpi;
	}

	public void setProductUpi(String productUpi) {
		this.productUpi = productUpi;
	}

	public String getFundCode() {
		return fundCode;
	}

	public void setFundCode(String fundCode) {
		this.fundCode = fundCode;
	}

	public String getFundName() {
		return fundName;
	}

	public void setFundName(String fundName) {
		this.fundName = fundName;
	}

	public String getExtrasName() {
		return extrasName;
	}

	public void setExtrasName(String extrasName) {
		this.extrasName = extrasName;
	}

	public String getHospitalName() {
		return hospitalName;
	}

	public void setHospitalName(String hospitalName) {
		this.hospitalName = hospitalName;
	}

	public String getPhioData() {
		return phioData;
	}

	public void setPhioData(String phioData) {
		this.phioData = phioData;
	}

	public void setAltHealthPricePremium(
			HealthPricePremium altHealthPricePremium) {
		this.altHealthPricePremium = altHealthPricePremium;
	}
	
	public void setHealthPricePremium(HealthPricePremium healthPricePremium) {
		this.healthPricePremium = healthPricePremium;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {return true;}
		if (!(obj instanceof HealthPriceResult)) {return false;}

		HealthPriceResult other = (HealthPriceResult) obj;
		return this.productId.equals(other.productId);
	}

	@Override
	public int hashCode(){
		return this.productId.hashCode();
	}

	@Override
	public String toString() {
		return "HealthPriceResult{" +
				"productId='" + productId + '\'' +
				", longTitle='" + longTitle + '\'' +
				", shortTitle='" + shortTitle + '\'' +
				", providerId=" + providerId +
				", productCat='" + productCat + '\'' +
				", productCode='" + productCode + '\'' +
				", excessAmount=" + excessAmount +
				", rank=" + rank +
				", isValid=" + isValid +
				", healthPricePremium=" + healthPricePremium +
				", altHealthPricePremium=" + altHealthPricePremium +
				", isDiscountRates=" + isDiscountRates +
				", productUpi='" + productUpi + '\'' +
				", fundCode='" + fundCode + '\'' +
				", fundName='" + fundName + '\'' +
				", extrasName='" + extrasName + '\'' +
				", hospitalName='" + hospitalName + '\'' +
				", phioData='" + phioData + '\'' +
				'}';
	}
}