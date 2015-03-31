package com.ctm.services.health;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.HealthAltPriceException;
import com.ctm.model.content.Content;
import com.ctm.model.content.ContentSupplement;
import com.ctm.model.health.HealthAlternatePricing;
import com.ctm.model.health.HealthPriceResult;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.ContentService;
import com.ctm.services.SettingsService;
import org.apache.log4j.Logger;
import org.json.JSONException;

import javax.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.Date;

public class HealthPriceDetailService {

	private static Logger logger = Logger.getLogger(HealthPriceDetailService.class.getName());
	private final ContentService contentService;

	private HealthPriceDao healthPriceDao;
	private HealthAlternatePricing alternatePricing = null;

	public HealthPriceDetailService() {
		this.healthPriceDao = new HealthPriceDao();
		contentService = new ContentService();
	}

	public HealthPriceDetailService(HealthPriceDao healthPriceDao, ContentService contentService) {
		this.healthPriceDao = healthPriceDao;
		this.contentService = contentService;
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
	 * internal soap call, can not get stylecode Id from request, has to be passed manually
	 */
	public Boolean isAlternatePriceDisabledForResult(HttpServletRequest request, int styleCodeId, HealthPriceResult healthPriceResult) throws HealthAltPriceException {

		if(alternatePricing == null) {
			createAlternatePricingModel(request, styleCodeId, 4);
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
			String[] fundList = new String[0];
			Content alternatePricingContent = contentService.getContent("alternatePricingActive", styleCodeId, verticalId, serverDate, true);

			if(alternatePricingContent != null){
				String supplementaryValueByKey = alternatePricingContent.getSupplementaryValueByKey("disabledFunds");

				if(supplementaryValueByKey != null) {
					fundList = supplementaryValueByKey.split(",");
				}
				if(fundList.length == 1 && fundList[0].isEmpty()) {
					fundList = new String[0];
				}

			} else {
				alternatePricingContent = new Content();
				alternatePricingContent.setContentValue("N");

				alternatePricingContent.setSupplementary(new ArrayList<ContentSupplement>());
			}

			String fromMonth = alternatePricingContent.getSupplementaryValueByKey("fromMonth") != null ? alternatePricingContent.getSupplementaryValueByKey("fromMonth") : "April";

			alternatePricing = new HealthAlternatePricing(
				alternatePricingContent.getContentValue() != null && alternatePricingContent.getContentValue().equalsIgnoreCase("Y"),
				fromMonth,
				fundList
			);
		} catch(DaoException e) {
			throw new HealthAltPriceException(e.getMessage(), e);
		}
	}

}
