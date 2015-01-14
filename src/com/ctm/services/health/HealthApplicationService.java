package com.ctm.services.health;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.Frequency;
import com.ctm.model.health.HealthApplicationRequest;
import com.ctm.model.health.HealthPricePremium;
import com.disc_au.price.health.PremiumCalculator;
import com.disc_au.web.go.Data;

public class HealthApplicationService {

	private HealthApplicationRequest request = new HealthApplicationRequest();
	private PremiumCalculator premiumCalculator = new PremiumCalculator();
	private HealthPriceDao healthPriceDao;

	public HealthApplicationService() {
		healthPriceDao = new HealthPriceDao();
	}

	public HealthApplicationService(HealthPriceDao healthPriceDao) {
		this.healthPriceDao = healthPriceDao;
	}

	public void calculatePremiums(Data data) throws DaoException {
		parseRequest(data);
		HealthPricePremium premium = fetchHealthResult();

		premiumCalculator.setRebate(request.rebate);
		premiumCalculator.setLoading(request.loading);
		premiumCalculator.setMembership(request.membership);

		int periods;

		switch(request.frequency){
			case WEEKLY:
				setUpPremiumCalculator(premium.getWeeklyPremium(), premium.getGrossWeeklyPremium(), premium.getWeeklyLhc());
				periods = 52;
				break;
			case FORTNIGHTLY:
				setUpPremiumCalculator(premium.getFortnightlyPremium(), premium.getGrossFortnightlyPremium(), premium.getFortnightlyLhc());
				periods = 26;
				break;
			case QUARTERLY:
				setUpPremiumCalculator(premium.getQuarterlyPremium(), premium.getGrossQuarterlyPremium(), premium.getQuarterlyLhc());
				periods = 4;
				break;
			case HALF_YEARLY:
				setUpPremiumCalculator(premium.getHalfYearlyPremium(), premium.getGrossHalfYearlyPremium(), premium.getHalfYearlyLhc());
				periods = 2;
				break;
			case ANNUALLY:
				setUpPremiumCalculator(premium.getAnnualPremium(), premium.getGrossAnnualPremium(), premium.getAnnualLhc());
				periods = 1;
				break;
			default:
				setUpPremiumCalculator(premium.getMonthlyPremium(), premium.getGrossMonthlyPremium(), premium.getMonthlyLhc());
				periods = 12;
		}

		double paymentAmt = premiumCalculator.getPremiumWithRebateAndLHC();

		data.put("health/application/paymentHospital", premiumCalculator.getLhc() * periods);
		data.put("health/application/grossPremium", premiumCalculator.getGrossPremium() * periods);
		data.put("health/application/paymentAmt", paymentAmt * periods);
		data.put("health/application/paymentFreq", paymentAmt);
		data.put("health/application/discountAmt", premiumCalculator.getDiscountValue() * periods);
		data.put("health/application/discount", premiumCalculator.getDiscountPercentage());
		data.put("health/loadingAmt", premiumCalculator.getLoadingAmount() * periods);
		data.put("health/rebateAmt", premiumCalculator.getRebateAmount() * periods);
	}

	private void parseRequest(Data data) {
		String frequencyCode = data.getString("health/payment/details/frequency");
		request.frequency = Frequency.findByDescription(frequencyCode);
		request.loading = data.getString("health/loading");
		request.membership =  data.getString("health/situation/healthCvr");
		request.selectedProductId = data.getString("health/application/productId").replace("PHIO-HEALTH-", "");
		request.rebate  = data.getDouble("health/rebate");
		request.provider = data.getString("health/application/provider");
		request.currentCustomer = data.getString("health/application/currentCustomer");
		request.paymentType = data.getString("health/payment/details/type");
	}

	/**
	 * Fetch single health product based on product id
	 */
	private HealthPricePremium fetchHealthResult() throws DaoException {
		boolean isDiscountRates = HealthPriceService.hasDiscountRates(request.frequency, request.provider,
				request.currentCustomer, request.paymentType, false);
		HealthPricePremium premium = healthPriceDao.getPremiumAndLhc(request.selectedProductId, isDiscountRates);
		return premium;
	}

	private void setUpPremiumCalculator(double premium, double grossPremium, double lhc) {
		premiumCalculator.setLhc(lhc);
		premiumCalculator.setBasePremium(premium);
		premiumCalculator.setGrossPremium(grossPremium);

	}
}
