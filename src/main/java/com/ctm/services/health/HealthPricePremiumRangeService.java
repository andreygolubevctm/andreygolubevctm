package com.ctm.services.health;

import java.math.BigDecimal;

import com.ctm.web.health.dao.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPricePremiumRange;
import com.ctm.model.health.HealthPriceRequest;
import com.disc_au.price.health.PremiumCalculator;

public class HealthPricePremiumRangeService {

	private HealthPriceDao healthPriceDao;
	private HealthPriceRequest healthPriceRequest;
	private HealthPricePremiumRange healthPricePremiumRange;
	private double rebate; // rebate after gov percentage, e.g. 29.04



	public HealthPricePremiumRangeService(HealthPriceRequest healthPriceRequest , double rebate, HealthPriceDao healthPriceDao) throws DaoException {
		this.healthPriceDao = healthPriceDao;
		this.healthPriceRequest = healthPriceRequest;
		this.rebate = rebate;
		setUpHealthPricePremiumRange();
		setUpPriceMinimum();
	}


	/**
	 * Set up minimum and maximum values for the health prices request. Used for the price filter
	 */
	private HealthPricePremiumRange setUpHealthPricePremiumRange() throws DaoException {
		healthPricePremiumRange = new HealthPricePremiumRange();
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


	private void setUpPriceMinimum() {
		double newMinimum = 0;
		double priceMinimum = healthPriceRequest.getPriceMinimum();
		if (healthPriceRequest.isOnResultsPage() && priceMinimum  > 0) {
			PremiumCalculator premiumCalculator = new PremiumCalculator();
			premiumCalculator.setRebate(rebate);
			newMinimum = premiumCalculator.getPremiumWithoutRebate(priceMinimum);

			// set minimum value to max if it exceeds the max in the database
			switch (healthPriceRequest.getPaymentFrequency()) {
			case FORTNIGHTLY:
				double maxFortnightly = healthPricePremiumRange.getMaxFortnightlyPremiumBase();
				double minFortnightly = healthPricePremiumRange.getMinFortnightlyPremium();
				if (newMinimum > maxFortnightly) {
					newMinimum = maxFortnightly;
				} else if (newMinimum <= minFortnightly) {
					newMinimum = 0;
				}
				break;
			case ANNUALLY:
				double maxAnnual = healthPricePremiumRange.getMaxYearlyPremiumBase();
				double minAnnual = healthPricePremiumRange.getMinYearlyPremium();
				if (newMinimum > maxAnnual) {
					newMinimum = maxAnnual;
				} else if (newMinimum <= minAnnual) {
					newMinimum = 0;
				}
				break;
			case MONTHLY:
				double maxMonthly = healthPricePremiumRange.getMaxMonthlyPremiumBase();
				double minMonthly = healthPricePremiumRange.getMinMonthlyPremium();
				if (newMinimum > maxMonthly) {
					newMinimum = maxMonthly;
				} else if (newMinimum <= minMonthly) {
					newMinimum = 0;
				}
				break;
			// if other frequency set to 0
			default:
				newMinimum = 0;
			}
		}
		healthPriceRequest.setPriceMinimum(newMinimum);
	}

	/**
	 * Get premium rounded down to the nearest $5 with rebate applied
	 * @param basePremium
	 * @return
	 */
	private double calculatePriceFilterPremium(double basePremium) {
		PremiumCalculator premiumCalculator = new PremiumCalculator();

		premiumCalculator.setRebate(rebate);
		premiumCalculator.setBasePremium(basePremium);

		// Get premium with rebate applied to it as is shown on the results page
		BigDecimal premium = premiumCalculator.getLHCFreeValueDecimal();

		// Round down to the nearest $5
		BigDecimal five = new BigDecimal(5);
		premium = premium.divide(five).setScale(0, BigDecimal.ROUND_DOWN).multiply(five);
		return premium.doubleValue();
	}

	public HealthPricePremiumRange getHealthPricePremiumRange() {
		return healthPricePremiumRange;
	}

}
