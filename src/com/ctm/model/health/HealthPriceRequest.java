package com.ctm.model.health;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

public class HealthPriceRequest {

	private String searchDate;
	private String state;
	private String membership;

	private String productType = "";
	private double rebate;
	private String loading;
	private int excessMax;
	private int excessMin;
	private String hospitalSelection;
	private String excludeStatus;
	private int tierHospital = -1;
	private int tierExtras = -1;
	private int providerId;
	private double priceMinimum;
	private int styleCodeId;
	private Date searchDateValue;
	private List<Integer> excludedProviders;

	/**
	 * Hospital Tier
	 * @return -1 if not defined, otherwise an integer 0 or greater.
	 */
	public int getTierHospital() {
		return tierHospital;
	}
	/**
	 * Set this property only if Tier is required, because 0 means "None"
	 */
	public void setTierHospital(int tierHospital) {
		this.tierHospital = tierHospital;
	}

	/**
	 * Extras Tier
	 * @return -1 if not defined, otherwise an integer 0 or greater.
	 */
	public int getTierExtras() {
		return tierExtras;
	}
	/**
	 * Set this property only if Tier is required, because 0 means "None"
	 */
	public void setTierExtras(int tierExtras) {
		this.tierExtras = tierExtras;
	}


	public String getLoading() {
		return loading;
	}

	public void setLoading(String loading) {
		this.loading = loading;
	}

	public double getRebate() {
		return rebate;
	}

	public void setRebate(double rebate) {
		this.rebate = rebate;
	}

	public String getHospitalSelection() {
		return this.hospitalSelection;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getProductType() {
		return productType;
	}

	public void setProductType(String productType) {
		this.productType = productType;
	}

	public String getSearchDate() {
		return searchDate;
	}

	public void setSearchDate(String searchDate) {
		this.searchDate = searchDate;
	}

	public String getMembership() {
		return membership;
	}

	public void setMembership(String membership) {
		this.membership = membership;
	}

	public int getExcessMin() {
		return excessMin;
	}

	public int getExcessMax() {
		return excessMax;
	}

	public void setExcessMax(int excessMax) {
		this.excessMax = excessMax;
	}

	public void setExcessMin(int excessMin) {
		this.excessMin = excessMin;
	}

	public void setHospitalSelection(String hospitalSelection) {
		this.hospitalSelection = hospitalSelection;
	}

	public String getExcludeStatus() {
		return excludeStatus;
	}

	public void setExcludeStatus(String excludeStatus) {
		this.excludeStatus = excludeStatus;
	}

	public int getProviderId() {
		return providerId;
	}

	public void setProviderId(int providerId) {
		this.providerId = providerId;
	}

	public double getPriceMinimum() {
		return priceMinimum;
	}

	public void setPriceMinimum(double priceMinimum) {
		this.priceMinimum = priceMinimum;
	}

	public int getStyleCodeId() {
		return styleCodeId;
	}

	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}

	public Date getSearchDateValue() {
		return searchDateValue;
	}

	public void setSearchDateValue(Date searchDateValue) {
		this.searchDateValue = searchDateValue;
	}

	public void setExcludedProviders(List<Integer> excludedProviders) {
		this.excludedProviders = excludedProviders;
	}

	public String getExcludedProviders() {
		return StringUtils.join(excludedProviders, ",");
	}

	public List<Integer> getExcludedProvidersList() {
		return excludedProviders;
	}
}
