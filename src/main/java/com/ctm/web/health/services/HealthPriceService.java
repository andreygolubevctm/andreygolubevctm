package com.ctm.web.health.services;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.dao.StyleCodeDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.FormDateUtils;
import com.ctm.web.health.dao.HealthPriceDao;
import com.ctm.web.health.model.*;
import com.ctm.web.health.services.results.ProviderRestrictionsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.health.model.Frequency.ANNUALLY;
import static com.ctm.web.health.model.Frequency.HALF_YEARLY;

public class HealthPriceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(HealthPriceService.class);

	private HealthPriceRequest healthPriceRequest;
	private HealthPriceDao healthPriceDao;
	private StyleCodeDao styleCodeDao;
	ProviderRestrictionsService providerRestrictionsService;

	private long transactionId;
	private boolean showAll;
	private double rebate;				// final rebate to be used
	private double rebateCurrent; 		// current rebate percentage	e.g. 29.04
	private double rebateChangeover;	// future rebate percentage		e.g. 28.65
	private Date changeoverDate;		// rebate changeover date	April 1st every year.
	private Date applicationDate;

	private HealthPricePremiumRange healthPricePremiumRange;

	/**
	 * Used by jsp
	**/
	public HealthPriceService() {
		healthPriceDao = new HealthPriceDao();
		styleCodeDao = new StyleCodeDao();
		providerRestrictionsService = new ProviderRestrictionsService();
	}

	public HealthPriceService(HealthPriceDao healthPriceDao, StyleCodeDao styleCodeDao, ProviderRestrictionsService providerRestrictionsService) {
		this.healthPriceDao = healthPriceDao;
		this.styleCodeDao = styleCodeDao;
		this.providerRestrictionsService = providerRestrictionsService;
	}

	public HealthPriceRequest getHealthPriceRequest() {
		return healthPriceRequest;
	}

	public void setHealthPriceRequest(HealthPriceRequest healthPriceRequest) {
		this.healthPriceRequest = healthPriceRequest;
	}

	public void setShowAll(boolean showAll) {
		this.showAll = showAll;
	}

	public void setChangeoverDate(Date changeoverDate) {
		this.changeoverDate = changeoverDate;
	}

	public double getRebate() {
		return rebate;
	}

	public double getRebateCurrent() {
		return rebateCurrent;
	}

	public void setRebateCurrent(double rebateCurrent) {
		this.rebateCurrent = rebateCurrent;
	}

	public double getRebateChangeover() {
		return rebateChangeover;
	}

	public void setRebateChangeover(double rebateChangeover) {
		this.rebateChangeover = rebateChangeover;
	}

	public long getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(long transactionId) {
		LoggingVariables.setTransactionId(TransactionId.instanceOf(transactionId));
		this.transactionId = transactionId;
	}

	public HealthPricePremiumRange getHealthPricePremiumRange() throws DaoException {
		return healthPricePremiumRange;
	}

	public Date getApplicationDate() {
		return applicationDate;
	}

	public void setApplicationDate(String dateString) {
		SimpleDateFormat isoDateFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy", Locale.ENGLISH);
		Date applicationDateValue = new Date();
		if (dateString != null && !dateString.isEmpty()) {
			try {
				applicationDateValue = isoDateFormat.parse(dateString);
			} catch (ParseException e) {
				LOGGER.warn("Unable to parse health application date", kv("dateString", dateString), e);
			}
		}
		this.applicationDate = applicationDateValue;
	}

	// Setting the algorithm search date based on either the PostPrice expected
	// date, the application start date or today's date
	public void setSearchDate(String searchDate) {
		SimpleDateFormat isoDateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
		Date searchDateValue  = new Date();
		if(!searchDate.isEmpty()) {
			//If date sent through as dd/MM/YYYY
			if (searchDate.contains("/")) {
				searchDateValue = FormDateUtils.parseDateFromForm(searchDate);
			//If date sent through as YYYY-MM-DD
			} else {
				try {
					searchDateValue = isoDateFormat.parse(searchDate);
				} catch (ParseException e) {
					LOGGER.warn("Unable to parse health search date {}", kv("searchDate", searchDate), e);
			}
		}
		}
		healthPriceRequest.setSearchDateValue(searchDateValue);
		healthPriceRequest.setSearchDate(isoDateFormat.format(searchDateValue));
	}

	public void setMembership(String membership) {
		if(membership.equalsIgnoreCase("SPF")){
			membership = "SP";
		} else if (membership.equalsIgnoreCase("SM")
				|| membership.equalsIgnoreCase("SF")) {
			membership = "S";
		}
		healthPriceRequest.setMembership(Membership.findByCode(membership));
	}

	public void setup() throws DaoException {
		LoggingVariables.setVerticalType(VerticalType.HEALTH);

		int excessMax;
		int excessMin;
		String excessSel = healthPriceRequest.getExcessSel();
		if (healthPriceRequest.getProductType().equals("GeneralHealth")) {
			excessMax = 99999;
			excessMin = 0;
		} else if (("1").equals(excessSel)) {
			excessMax = 0;
			excessMin = 0;
		} else if (("2").equals(excessSel)) {
			excessMax = 250;
			excessMin = 1;
		} else if (("3").equals(excessSel)) {
			excessMax = 500;
			excessMin = 251;
		} else {
			excessMax = 99999;
			excessMin = 0;
		}
		healthPriceRequest.setExcessMax(excessMax);
		healthPriceRequest.setExcessMin(excessMin);

		providerRestrictionsService.setUpExcludedProviders(healthPriceRequest, transactionId);

		setUpStyleCodeId();
		setUpHospitalSelection();
		setUpExcludeStatus();
		setUpRebate();
		HealthPricePremiumRangeService healthPricePremiumRangeService = new HealthPricePremiumRangeService(healthPriceRequest , rebate, healthPriceDao);
		healthPricePremiumRange = healthPricePremiumRangeService.getHealthPricePremiumRange();
		setUpLoadingPerc();
	}

	private void setUpHospitalSelection() {

		HospitalSelection hospitalSelection;
		if (healthPriceRequest.getProductType().equals("GeneralHealth")) {
			hospitalSelection = HospitalSelection.BOTH;
		} else if (!healthPriceRequest.isPrivateHospital() && !healthPriceRequest.isPublicHospital()) {
			if (healthPriceRequest.getTierHospital() == 1) {
				// Show both Public/Private because user selected 'Public' tier
				hospitalSelection = HospitalSelection.BOTH;
			} else {
				// If user chooses neither Public nor Private, business decision
				// is to show Private (i.e. hide Public products)
				hospitalSelection = HospitalSelection.PRIVATE_HOSPITAL;
			}
		} else if (healthPriceRequest.isPrivateHospital()) {
			hospitalSelection = HospitalSelection.PRIVATE_HOSPITAL;
		} else {
			hospitalSelection = HospitalSelection.BOTH;
		}
		healthPriceRequest.setHospitalSelection(hospitalSelection);
	}

	private void setUpExcludeStatus() {
		List<ProductStatus> excludeStatus = new ArrayList<ProductStatus>();
		if (healthPriceRequest.getIsSimples() && !showAll) {
			excludeStatus.add(ProductStatus.NOT_AVAILABLE);
			excludeStatus.add(ProductStatus.EXPIRED);
		} else if (healthPriceRequest.getIsSimples()) {
			excludeStatus.add(ProductStatus.NOT_AVAILABLE);
			excludeStatus.add(ProductStatus.EXPIRED);
			excludeStatus.add(ProductStatus.ONLINE);
		} else {
			excludeStatus.add(ProductStatus.NOT_AVAILABLE);
			excludeStatus.add(ProductStatus.EXPIRED);
			excludeStatus.add(ProductStatus.CALL_CENTRE);
		}
		healthPriceRequest.setExcludeStatus(excludeStatus);
	}


	private void setUpStyleCodeId()  {
		try {
			healthPriceRequest.setStyleCodeId(styleCodeDao.getStyleCodeId(transactionId));
		} catch (DaoException e) {
			LOGGER.error("Failed to Style Code Id", e);
			healthPriceRequest.setStyleCodeId(0);
		}
	}

	private void setUpRebate() throws DaoException {
		this.rebate = 0.0;

		if (!healthPriceRequest.getSearchDateValue().before(changeoverDate)) {
			this.rebate = rebateChangeover;
		} else if (rebateCurrent > 0) {
			this.rebate = rebateCurrent;
		}
	}

	private void setUpLoadingPerc() {
		double loadingPerc = 0.0;

		if (healthPriceRequest.getLoading() > 0) {
			loadingPerc = healthPriceRequest.getLoading() * 0.01;
}

		healthPriceRequest.setLoadingPerc(loadingPerc);
	}

	/**
	 * set up alternate product Id for returned result
	 */
	public HealthPriceResult setUpProductUpi(HealthPriceResult healthPriceResult) throws DaoException {
		return healthPriceDao.setUpProductUpi(healthPriceRequest, healthPriceResult);
	}


	/**
         DISCOUNT HACK: NEEDS TO BE REVISED
         if onResultsPage = true
         = No Discount

         else if NIB + Bank account
         = Discount

         else if GMHBA + Bank account
         = Discount

         else if GMF + Annualy payment
         = Discount

         else if HIF + Annualy/Halfyealy payment
         = Discount

         else if AUF
         = Discount

         else
         = No Discount

         1=AUF, 3=NIB, 5=GMHBA, 6=GMF, 54=BUD, 11=HIF
	 **/
	public static boolean hasDiscountRates(Frequency frequency, String provider, PaymentType paymentType, boolean onResultsPage) {
		if(onResultsPage) {
			return false;
		}
		boolean isBankAccount = paymentType != null && paymentType == PaymentType.BANK;
		switch(provider){
			case "NIB":
				return isBankAccount;
			case "GMH":
				return isBankAccount;
			case "GMF":
				return  frequency.equals(ANNUALLY);
			case "HIF":
				return frequency.equals(ANNUALLY) || frequency.equals(HALF_YEARLY);
			case "AUF":
				return true;
			default:
				return false;
		}
	}

	public boolean hasDiscountRates(String provider, String paymentType) {
		return hasDiscountRates(healthPriceRequest.getPaymentFrequency(), provider, PaymentType.findByCode(paymentType), healthPriceRequest.isOnResultsPage());
	}


}