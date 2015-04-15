package com.ctm.model.health;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class HealthPriceRequest {

	private String searchDate;
	private String state;
	private Membership membership;
	private String productType = "";
	private int loading;
	private double loadingPerc;
	private int excessMax;
	private int excessMin;
	private HospitalSelection hospitalSelection;
	private List<ProductStatus> excludeStatus;
	private int tierHospital = -1;
	private int tierExtras = -1;
	private int providerId = 0;
	private double priceMinimum;
	private int styleCodeId;
	private Date searchDateValue;
	private List<Integer> excludedProviders;
	private List<String> preferences;
	private Frequency paymentFrequency;
	private int searchResults = 12;
	private boolean retrieveSavedResults;
	private long savedTransactionId;
	private String selectedProductId;
	private String productTitle;
	private boolean onResultsPage;
	private boolean directApplication;
	private boolean simples;
	private boolean pricesHaveChanged;
	private boolean privateHospital;
	private boolean publicHospital;
	private String excessSel;
	private String brandFilter = "";
	private List<Integer> providersThatHaveExceededLimit;

	public void setPrivateHospital(boolean privateHospital) {
		this.privateHospital = privateHospital;
	}

	public boolean isPrivateHospital() {
		return privateHospital;
	}

	public boolean isPublicHospital() {
		return publicHospital;
	}

	public void setPublicHospital(boolean publicHospital) {
		this.publicHospital = publicHospital;
	}

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


	public int getLoading() {
		return loading;
	}

	public void setLoading(int loading) {
		this.loading = loading;
	}

	public double getLoadingPerc() {
		return loadingPerc;
	}

	public void setLoadingPerc(double loadingPerc) {
		this.loadingPerc = loadingPerc;
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
		return membership.getCode();
	}

	public void setMembership(Membership membership) {
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

	public String getHospitalSelection() {
		return hospitalSelection.getCode();
	}

	public void setHospitalSelection(HospitalSelection hospitalSelection) {
		this.hospitalSelection = hospitalSelection;
	}

	public List<ProductStatus> getExcludeStatus() {
		return excludeStatus;
	}

	public void setExcludeStatus(List<ProductStatus> excludeStatus) {
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

	public List<String> getPreferences() {
		return preferences;
	}

	public void setPreferences(String preferencesString) {
		this.preferences = new ArrayList<String>();
		for (String preference : preferencesString.split(",")) {
			if (!preference.isEmpty()) {
				this.preferences.add(preference);
			}
		}
	}

	public Frequency getPaymentFrequency() {
		return paymentFrequency;
	}

	public void setPaymentFrequency(String frequencyCode) {
		this.paymentFrequency = Frequency.findByCode(frequencyCode);
	}

	public int getSearchResults() {
		return searchResults;
	}

	public void setSearchResults(int searchResults) {
		this.searchResults = searchResults;
	}

	public boolean getRetrieveSavedResults() {
		return retrieveSavedResults;
	}

	public void setRetrieveSavedResults(boolean retrieveSavedResults) {
		this.retrieveSavedResults = retrieveSavedResults;
	}

	public long getSavedTransactionId() {
		return savedTransactionId;
	}

	public void setSavedTransactionId(long savedTransactionId) {
		this.savedTransactionId = savedTransactionId;
	}

	public String getSelectedProductId() {
		return selectedProductId;
	}

	public void setSelectedProductId(String selectedProductId) {
		this.selectedProductId = selectedProductId;
	}

	public String getProductTitle() {
		return productTitle;
	}

	public void setProductTitle(String productTitle) {
		this.productTitle = productTitle;
	}
	public boolean isOnResultsPage() {
		return onResultsPage;
	}

	public void setOnResultsPage(boolean onResultsPage) {
		this.onResultsPage = onResultsPage;
	}

	public void setDirectApplication(boolean directApplication){
		this.directApplication = directApplication;
	}
	public boolean isDirectApplication() {
		return directApplication;
	}
	public void setIsSimples(boolean isSimples) {
		this.simples = isSimples;
	}
	public boolean getIsSimples() {
		return simples;
	}
	public void setPricesHaveChanged(boolean pricesHaveChanged) {
		this.pricesHaveChanged = pricesHaveChanged;
	}
	public boolean getPricesHaveChanged() {
		return pricesHaveChanged;
	}

	public String getExcessSel() {
		return excessSel;
	}

	public void setBrandFilter(String brandFilter) {
		this.brandFilter = brandFilter.replaceAll("[^0-9,]", "");
	}

	public void setExcessSel(String excessSel) {
		this.excessSel = excessSel;
	}

	public String getBrandFilter() {
		return brandFilter;
	}

	public void setProvidersThatHaveExceededLimit(List<Integer> providersThatHaveExceededLimit) {
		this.providersThatHaveExceededLimit = providersThatHaveExceededLimit;
}

	public List<Integer> getProvidersThatHaveExceededLimit() {
		return providersThatHaveExceededLimit;
	}
}
