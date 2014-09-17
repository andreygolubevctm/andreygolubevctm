package com.ctm.services.health;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.apache.log4j.Logger;

import com.ctm.dao.StyleCodeDao;
import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPricePremiumRange;
import com.ctm.model.health.HealthPriceRequest;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.results.ProviderRestrictionsService;
import com.disc_au.price.health.PremiumCalculator;

public class HealthPriceService {


	private static Logger logger = Logger.getLogger(HealthPriceService.class.getName());

	private HealthPriceRequest healthPriceRequest = new HealthPriceRequest();
	private HealthPriceDao healthPriceDao;
	ProviderRestrictionsService providerRestrictionsService = new ProviderRestrictionsService();

	private String excessSel = "";
	private boolean privateHospital;
	private boolean publicHospital;
	private boolean pricesHaveChanged = false;
	private long transactionId;
	private boolean onResultsPage;
	private boolean isSimples;
	private boolean showAll;
	private double priceMinimum;
	private String brandFilter = "";
	private double rebateCalc;
	private double rebateMultiplierCurrent;
	private Date changeoverDate;
	private double rebateChangeover;

	private HealthPricePremiumRange healthPricePremiumRange;

	private String paymentFrequency;

	public HealthPriceService() {
		healthPriceDao = new HealthPriceDao();
	}

	public HealthPriceService(HealthPriceDao healthPriceDao){
		this.healthPriceDao = healthPriceDao;
	}

	public void setIsSimples(boolean isSimples) {
		this.isSimples = isSimples;
	}

	public void setShowAll(boolean showAll) {
		this.showAll = showAll;
	}

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

	public void setProviderId(int providerId) {
		healthPriceRequest.setProviderId(providerId);
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

	public void setRebate(double rebate) {
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

	public void setRebateMultiplierCurrent(double rebateMultiplierCurrent) {
		this.rebateMultiplierCurrent = rebateMultiplierCurrent;
	}

	public void setChangeoverDate(Date changeoverDate) {
		this.changeoverDate = changeoverDate;
	}

	public void setRebateChangeover(double rebateChangeover) {
		this.rebateChangeover = rebateChangeover;
	}

	// Setting the algorithm search date based on either the PostPrice expected date, the application start date or today's date
	public void setSearchDate(String searchDate) {
		SimpleDateFormat isoDateFormat = new SimpleDateFormat("YYYY-MM-dd", Locale.ENGLISH);
		Date searchDateValue  = new Date();
		if(!searchDate.isEmpty()) {
			//If date sent through as dd/MM/YYYY
			if (searchDate.contains("/")) {
				SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
				try {
					searchDateValue = formatter.parse(searchDate);
				} catch (ParseException e) {
					logger.warn("failed to parse" + searchDate , e);
				}
			//If date sent through as YYYY-MM-DD
			} else {
				try {
					searchDateValue = isoDateFormat.parse(searchDate);
				} catch (ParseException e) {
					logger.warn("failed to parse" + searchDate , e);
			}
		}
		}
		healthPriceRequest.setSearchDateValue(searchDateValue);
		healthPriceRequest.setSearchDate(isoDateFormat.format(searchDateValue));
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
		return healthPriceRequest;
	}

	public void setup() throws DaoException {

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

		setUpStyleCodeId();

		setUpHospitalSelection();
		setUpExcludeStatus();
		setUpExcludedProviders();
		setUpRebateMultiplier();
		setUpHealthPricePremiumRange();
		setUpPriceMinimum();
	}

	public HealthPricePremiumRange getHealthPricePremiumRange() throws DaoException {
		return healthPricePremiumRange;
	}

	/**
	 * Set up minimum and maximum values for the health prices request. Used for the price filter
	 * @param basePremium
	 * @return
	 */
	private HealthPricePremiumRange setUpHealthPricePremiumRange() throws DaoException {
		healthPricePremiumRange = healthPriceDao.getHealthPricePremiumRange(healthPriceRequest);

		double maxFortnightlyPremiumBase = healthPricePremiumRange.getMaxFortnightlyPremium();
		healthPricePremiumRange.setMaxFortnightlyPremiumBase(maxFortnightlyPremiumBase);
		healthPricePremiumRange.setMaxFortnightlyPremium(calculatePriceFilterPremium(maxFortnightlyPremiumBase));

		double maxMonthlyPremium = healthPricePremiumRange.getMaxMonthlyPremium();
		healthPricePremiumRange.setMaxMonthlyPremiumBase(maxMonthlyPremium);
		healthPricePremiumRange.setMaxMonthlyPremium(calculatePriceFilterPremium(maxMonthlyPremium));

		double maxYearlyPremium = healthPricePremiumRange.getMaxYearlyPremium();
		healthPricePremiumRange.setMaxYearlyPremiumBase(maxYearlyPremium);
		healthPricePremiumRange.setMaxYearlyPremium(calculatePriceFilterPremium(maxYearlyPremium));

		healthPricePremiumRange.setMinFortnightlyPremium(calculatePriceFilterPremium(healthPricePremiumRange.getMinFortnightlyPremium()));
		healthPricePremiumRange.setMinMonthlyPremium(calculatePriceFilterPremium(healthPricePremiumRange.getMinMonthlyPremium()));
		healthPricePremiumRange.setMinYearlyPremium(calculatePriceFilterPremium(healthPricePremiumRange.getMinYearlyPremium()));

		return healthPricePremiumRange;
	}

	/**
	 * Get premium rounded down to the nearest $5 with rebate applied
	 * @param basePremium
	 * @return
	 */
	private double calculatePriceFilterPremium(double basePremium) {
		PremiumCalculator premiumCalculator = new PremiumCalculator();

		premiumCalculator.setRebateCalc(rebateCalc);
		premiumCalculator.setBasePremium(basePremium);

		// Get premium with rebate applied to it as is shown on the results page
		BigDecimal premium = premiumCalculator.getLHCFreeValueDecimal();

		// Round down to the nearest $5
		BigDecimal five = new BigDecimal(5);
		premium = premium.divide(five).setScale(0, BigDecimal.ROUND_DOWN).multiply(five);
		return premium.doubleValue();
	}

	public String getFilterLevelOfCover() {
		return healthPriceDao.getFilterLevelOfCover(healthPriceRequest);
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

	public void setPriceMinimum(double priceMinimum) {
		this.priceMinimum = priceMinimum;
	}

	public void setExcludeStatus(String excludeStatus) {
		healthPriceRequest.setExcludeStatus(excludeStatus);
	}

	public void setPaymentFrequency(String paymentFrequency) {
		this.paymentFrequency = paymentFrequency;
	}

	private void setUpHospitalSelection() {

		String hospitalSelection;
		if (healthPriceRequest.getProductType().equals("GeneralHealth")) {
			hospitalSelection = "BOTH";
		} else if (!privateHospital && !publicHospital) {
			if (healthPriceRequest.getTierHospital() == 1) {
				// Show both Public/Private because user selected 'Public' tier
				hospitalSelection = "BOTH";
			} else {
				// If user chooses neither Public nor Private, business decision
				// is to show Private (i.e. hide Public products)
				hospitalSelection = "PrivateHospital";
			}
		} else if (privateHospital) {
			hospitalSelection = "PrivateHospital";
		} else if (publicHospital) {
			hospitalSelection = "BOTH";
		} else {
			hospitalSelection = "BOTH";
		}
		healthPriceRequest.setHospitalSelection(hospitalSelection);
	}

	private void setUpExcludeStatus() {
		String excludeStatus = "";
		if (isSimples && !showAll) {
			excludeStatus = "'N','X'";
		} else if (isSimples && showAll) {
			excludeStatus = "'N','X','O'";
		} else {
			excludeStatus = "'N','X','C'";
		}
		healthPriceRequest.setExcludeStatus(excludeStatus);
	}

	private void setUpPriceMinimum() {
		double newMinimum = 0;
		if(onResultsPage && priceMinimum > 0) {
			PremiumCalculator premiumCalculator = new PremiumCalculator();
			premiumCalculator.setRebateCalc(rebateCalc);
			newMinimum = premiumCalculator.getPremiumWithoutRebate(priceMinimum);

			// set minimum value to max if it exceeds the max in the database
			switch(paymentFrequency) {
				case "F" :
					double maxFortnightly = healthPricePremiumRange.getMaxFortnightlyPremiumBase();
					double minFortnightly = healthPricePremiumRange.getMinFortnightlyPremium();
					if(newMinimum > maxFortnightly) {
						newMinimum = maxFortnightly;
					} else if(newMinimum <= minFortnightly) {
						newMinimum = 0;
					}
					break;
				case "A" :
					double maxAnnual = healthPricePremiumRange.getMaxYearlyPremiumBase();
					double minAnnual = healthPricePremiumRange.getMinYearlyPremium();
					if(newMinimum > maxAnnual) {
						newMinimum = maxAnnual;
					} else if(newMinimum <= minAnnual) {
						newMinimum = 0;
					}
					break;
				case "M" :
					double maxMonthly = healthPricePremiumRange.getMaxMonthlyPremiumBase();
					double minMonthly = healthPricePremiumRange.getMinMonthlyPremium();
					if(newMinimum > maxMonthly) {
						newMinimum = maxMonthly;
					} else if(newMinimum <= minMonthly) {
						newMinimum = 0;
					}
					break;
			}
		}
		healthPriceRequest.setPriceMinimum(newMinimum);
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
			providersThatHaveExceededLimit = providerRestrictionsService.getProvidersThatHaveExceededLimit(healthPriceRequest.getState(), VerticalType.HEALTH.getCode(), transactionId);
		} else {
			// Check for hard limits
			providersThatHaveExceededLimit = providerRestrictionsService.getProvidersThatHaveExceededMonthlyLimit(healthPriceRequest.getState(), VerticalType.HEALTH.getCode(), transactionId);
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

	private void setUpStyleCodeId()  {
		StyleCodeDao styleCodeDao = new StyleCodeDao();
		try {
			healthPriceRequest.setStyleCodeId(styleCodeDao.getStyleCodeId(transactionId));
		} catch (DaoException e) {
			logger.error("failed to get Style Code Id" , e);
			healthPriceRequest.setStyleCodeId(0);
		}
	}

	private void setUpRebateMultiplier() throws DaoException {
		this.rebateCalc = 0.0;

		if(!changeoverDate.before(healthPriceRequest.getSearchDateValue())) {
			this.rebateCalc = rebateChangeover * 0.01;
		} else if (healthPriceRequest.getRebate() > 0) {
			this.rebateCalc = (healthPriceRequest.getRebate() * rebateMultiplierCurrent) * 0.01;
		}
	}

}
