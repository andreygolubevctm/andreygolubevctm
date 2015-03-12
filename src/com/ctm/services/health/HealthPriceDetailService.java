package com.ctm.services.health;

import java.util.List;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPriceResult;

public class HealthPriceDetailService {


	private HealthPriceDao healthPriceDao;


	public HealthPriceDetailService() {
		this.healthPriceDao = new HealthPriceDao();
	}

	public HealthPriceDetailService(HealthPriceDao healthPriceDao) {
		this.healthPriceDao = healthPriceDao;
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
	 * Check if dual pricing has been turned off for the fund
	 */
	public boolean isAlternatePriceDisabled(HealthPriceResult healthPriceResult) throws DaoException {

		boolean alternatePriceDisabled = false;
		List<String> disabledFunds = healthPriceDao.getDualPricingDisabledFunds();

		if (disabledFunds.contains(healthPriceResult.getFundCode())) {
			alternatePriceDisabled = true;
		}

		return alternatePriceDisabled;
	}

}
