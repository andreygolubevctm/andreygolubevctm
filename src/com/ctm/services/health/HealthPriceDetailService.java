package com.ctm.services.health;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.HealthAltPriceException;
import com.ctm.model.content.Content;
import com.ctm.model.health.HealthAlternatePricing;
import com.ctm.model.health.HealthPriceResult;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.ContentService;
import com.ctm.services.SettingsService;
import org.apache.log4j.Logger;
import org.json.JSONException;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

public class HealthPriceDetailService {

	private static Logger logger = Logger.getLogger(HealthPriceDetailService.class.getName());
	private Integer styleCodeId;

	private HealthPriceDao healthPriceDao;

	private HealthAlternatePricing alternatePricing = null;
	private Content alternatePricingContent;

	public HealthPriceDetailService() {
		this.healthPriceDao = new HealthPriceDao();
	}

	public HealthPriceDetailService(HealthPriceDao healthPriceDao , Integer styleCodeId, Content alternatePricingContent) {
		this.healthPriceDao = healthPriceDao;
		this.styleCodeId = styleCodeId;
		this.alternatePricingContent = alternatePricingContent;
	}

	/**
	 * set up extra cover name for returned result
	 */
	public HealthPriceResult setUpExtraName(HealthPriceResult healthPriceResult) throws DaoException {
		return healthPriceDao.setUpExtraName(healthPriceResult);
	}

	/**
	 * set up hospital cover name for returned result
	 */
	public HealthPriceResult setUpHospitalName(HealthPriceResult healthPriceResult) throws DaoException {
		return healthPriceDao.setUpHospitalName(healthPriceResult);
	}

	/**
	 * set up phio data for returned result
	 */
	public HealthPriceResult setUpPhioData(HealthPriceResult healthPriceResult) throws DaoException {
		return healthPriceDao.setUpPhioData(healthPriceResult);
	}

	/**
	 * set up fund code (active fund) and name
	 */
	public HealthPriceResult setUpFundCodeAndName(HealthPriceResult healthPriceResult) throws DaoException {
		return healthPriceDao.setUpFundCodeAndName(healthPriceResult);
	}

	/**
	 * set up premiums and lhcs
	 */
	public HealthPriceResult setUpPremiumAndLhc(HealthPriceResult healthPriceResult, boolean isAlt) throws DaoException {
		return healthPriceDao.setUpPremiumAndLhc(healthPriceResult, isAlt);
	}

	/**
	 * set up if it should use a discount rates
	 */
	public HealthPriceResult setUpDiscountRates(HealthPriceResult healthPriceResult, boolean discountRates) {
		healthPriceResult.setDiscountRates(discountRates);
		return healthPriceResult;
	}

	/**
	 * Check if alternate pricing has been turned off for the fund
	 */
	public Boolean isAlternatePriceDisabledForResult(HttpServletRequest request, HealthPriceResult healthPriceResult) throws HealthAltPriceException {

		if(alternatePricing == null) {
			createAlternatePricingModel(request, 4);
		}

		return alternatePricing.isProviderDisabled(healthPriceResult.getFundCode());
	}

	/**
	 * Check if alternate pricing has been turned off universally
	 */
	public Boolean isAlternatePriceActive(HttpServletRequest request) throws HealthAltPriceException {

		if(alternatePricing == null) {
			createAlternatePricingModel(request);
		}

		return alternatePricing.getIsActive();
	}

	public String getAlternatePriceMonth(HttpServletRequest request) throws HealthAltPriceException {

		if(alternatePricing == null) {
			createAlternatePricingModel(request);
		}

		return alternatePricing.getFromMonth();
	}

	public String getAlternatePricingJSON(HttpServletRequest request) throws HealthAltPriceException {

		String json = null;

		if(alternatePricing == null) {
			createAlternatePricingModel(request);
		}

		try {
			json = alternatePricing.toJSON().toString();
		} catch(JSONException e) {
			throw new HealthAltPriceException(e.getMessage(), e);
		}

		return json;
	}

	private void createAlternatePricingModel(HttpServletRequest request, Integer verticalId) throws HealthAltPriceException {
		try {
			if(styleCodeId == null){
				styleCodeId = ApplicationService.getBrandFromRequest(request).getId();
			}
			createAlternatePricingModel(request, styleCodeId, verticalId);
		} catch(DaoException e) {
			throw new HealthAltPriceException(e.getMessage(), e);
		}
	}

	private void createAlternatePricingModel(HttpServletRequest request) throws HealthAltPriceException {
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			Integer brandId = pageSettings.getBrandId();
			Integer verticalId = pageSettings.getVertical().getId();
			createAlternatePricingModel(request, brandId, verticalId);
		} catch(ConfigSettingException | DaoException e) {
			throw new HealthAltPriceException(e.getMessage(), e);
		}
	}

	private void createAlternatePricingModel(HttpServletRequest request, Integer styleCodeId, Integer verticalId) throws HealthAltPriceException {

		Date serverDate = ApplicationService.getApplicationDate(request);
		try {
			if(alternatePricingContent == null){
				alternatePricingContent = ContentService.getContent("alternatePricingActive", styleCodeId, verticalId, serverDate, true);
			}
			String supplementaryValueByKey = alternatePricingContent.getSupplementaryValueByKey("disabledFunds");
			String[] fundList = new String[0];
			if(supplementaryValueByKey != null) {
				fundList = supplementaryValueByKey.split(",");
			}
			if(fundList.length == 1 && fundList[0].isEmpty()) {
				fundList = new String[0];
			}
			alternatePricing = new HealthAlternatePricing(
				alternatePricingContent.getContentValue() != null && alternatePricingContent.getContentValue().equalsIgnoreCase("Y"),
				alternatePricingContent.getSupplementaryValueByKey("fromMonth"),
				fundList
			);
		} catch(DaoException e) {
			throw new HealthAltPriceException(e.getMessage(), e);
		}
	}

}
