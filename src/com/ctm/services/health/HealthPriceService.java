package com.ctm.services.health;

import java.util.ArrayList;
import java.util.List;

import com.ctm.model.health.HealthPriceRequest;
import com.ctm.services.results.ProviderRestrictionsService;

public class HealthPriceService {

	private HealthPriceRequest healthPriceRequest = new HealthPriceRequest();
	private String excessSel = "";
	private boolean privateHospital;
	private boolean publicHospital;
	private boolean pricesHaveChanged = false;
	private long transactionId;
	private String brandFilter;
	private boolean onResultsPage;

	public boolean getPricesHaveChanged() {
		return pricesHaveChanged;
	}

	public void setPricesHaveChanged(boolean pricesHaveChanged) {
		this.pricesHaveChanged = pricesHaveChanged;
	}

	public void setTierHospital(int tierHospital) {
		healthPriceRequest.setTierHospital(tierHospital);
	}

	public void setTierExtras(int tierExtras) {
		healthPriceRequest.setTierExtras(tierExtras);
	}

	public void setPrivateHospital(boolean privateHospital) {
		this.privateHospital = privateHospital;
	}

	public void setPublicHospital(boolean publicHospital) {
		this.publicHospital = publicHospital;
	}

	public void setLoading(String loading) {
		healthPriceRequest.setLoading(loading);
	}

	public void setRebate(String rebate) {
		healthPriceRequest.setRebate(rebate);
	}

	public void setExcessSel(String excessSel) {
		this.excessSel = excessSel;
	}

	public void setState(String state) {
		healthPriceRequest.setState(state);
	}

	public void setProductType(String productType) {
		healthPriceRequest.setProductType(productType);
	}

	public void setSearchDate(String searchDate) {
		healthPriceRequest.setSearchDate(searchDate);
	}

	public void setMembership(String membership) {
		switch(membership) {
			case "S":
				healthPriceRequest.setMembership("S");
				break;
			case "C":
					healthPriceRequest.setMembership("C");
					break;
			case "SPF":
				// map to database value of "SP"
				healthPriceRequest.setMembership("SP");
				break;
			case "F":
				healthPriceRequest.setMembership("F");
				break;
		}
	}

	public HealthPriceRequest getHealthPriceRequest() {

		int excessMax;
		int excessMin;
		if (healthPriceRequest.getProductType().equals("GeneralHealth")) {
			excessMax = 99999;
			excessMin = 0;
		} else if (this.excessSel.equals("1")) {
			excessMax = 0;
			excessMin = 0;
		} else if (this.excessSel.equals("2")) {
			excessMax = 250;
			excessMin = 1;
		} else if (this.excessSel.equals("3")) {
			excessMax = 500;
			excessMin = 251;
		} else {
			excessMax = 99999;
			excessMin = 0;
		}
		healthPriceRequest.setExcessMax(excessMax);
		healthPriceRequest.setExcessMin(excessMin);

		setUpHospitalSelection();
		setUpExcludedProviders();

		return healthPriceRequest;
	}

	public String getFilterLevelOfCover() {
		String filterLevelOfCover = "";
		if (healthPriceRequest.getTierHospital() != null && healthPriceRequest.getTierHospital() > 0) {
			filterLevelOfCover = "INNER JOIN ctm.product_properties locPP ON search.ProductId = locPP.ProductId "
					+ "AND locPP.PropertyId = 'TierHospital' AND locPP.SequenceNo = 0 "
					+ "AND locPP.Value >= " + healthPriceRequest.getTierHospital() + " ";
		}
		if (healthPriceRequest.getTierExtras() != null && healthPriceRequest.getTierExtras() > 0) {
			filterLevelOfCover += "INNER JOIN ctm.product_properties locPPe ON search.ProductId = locPPe.ProductId "
					+ "AND locPPe.PropertyId = 'TierExtras' AND locPPe.SequenceNo = 0 "
					+ "AND locPPe.Value >= " + healthPriceRequest.getTierExtras() + " ";
		}
		return filterLevelOfCover;
	}

	public void setExcludeStatus(String excludeStatus) {
		healthPriceRequest.setExcludeStatus(excludeStatus);
	}

	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public void setBrandFilter(String brandFilter) {
		this.brandFilter = brandFilter.replaceAll("[^0-9,]", "");
	}

	public void setOnResultsPage(boolean onResultsPage) {
		this.onResultsPage = onResultsPage;
	}

	protected void setUpHospitalSelection() {
		String hospitalSelection;
		if (healthPriceRequest.getProductType().equals("GeneralHealth")) {
			hospitalSelection = "Both";
		} else if (!privateHospital && !publicHospital) {
			if (healthPriceRequest.getTierHospital() != null && healthPriceRequest.getTierHospital() == 1) {
				// Show both Public/Private because user selected 'Public' tier
				hospitalSelection = "Both";
			} else {
				// If user chooses neither Public nor Private, business decision
				// is to show Private (i.e. hide Public products)
				hospitalSelection = "PrivateHospital";
			}
		} else if (privateHospital) {
			hospitalSelection = "PrivateHospital";
		} else if (publicHospital) {
			hospitalSelection = "Both";
		} else {
			hospitalSelection = "Both";
		}
		healthPriceRequest.setHospitalSelection(hospitalSelection);
	}

	/**
	 * Set the provider exclusion from both the request and the restrictions in the database
	 */
	private List<Integer> setUpExcludedProviders() {
		List<Integer> excludedProviders = new ArrayList<Integer>();

		// Add providers that have been excluded in the request
		for(String providerId : brandFilter.split(",")) {
			if(!providerId.isEmpty()){
				excludedProviders.add(Integer.parseInt(providerId));
			}
		}

		ProviderRestrictionsService providerRestrictionsService = new ProviderRestrictionsService();
		List<Integer> providersThatHaveExceededLimit;

		if(onResultsPage) {
			// Check for soft limits
			providersThatHaveExceededLimit = providerRestrictionsService.getProvidersThatHaveExceededLimit(healthPriceRequest.getState(), "HEALTH", transactionId);
		} else {
			// Check for hard limits
			providersThatHaveExceededLimit = providerRestrictionsService.getProvidersThatHaveExceededMonthlyLimit(healthPriceRequest.getState(), "HEALTH", transactionId);
		}

		// Add providers that have been excluded in the database
		for(Integer providerId : providersThatHaveExceededLimit) {
			if(!excludedProviders.contains(providerId)) {
				excludedProviders.add(providerId);
			}
		}

		healthPriceRequest.setExcludedProviders(excludedProviders);
		return excludedProviders;
	}

}
