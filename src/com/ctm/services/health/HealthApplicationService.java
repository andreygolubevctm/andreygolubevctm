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
	private HealthPriceDao healthPriceDao;

	public HealthApplicationService() {
		healthPriceDao = new HealthPriceDao();
	}
	
	public HealthApplicationService(HealthPriceDao healthPriceDao) {
		this.healthPriceDao = healthPriceDao;
	}
	
	public void calculatePremiums(Data data, double rebateMultiplierCurrent) throws DaoException {
		parseRequest(data);
		HealthPricePremium premium = fetchHealthResult();
		double paymentAmt = 0;
		double annualAmount;
		double rebateCalcReal = (request.rebate * rebateMultiplierCurrent);
		switch(request.frequency){
			case WEEKLY:
				paymentAmt = calculatePaymentAmt(premium.getWeeklyPremium(), premium.getWeeklyLhc(), rebateCalcReal);
				annualAmount = 52 * paymentAmt;
				break;
			case FORTNIGHTLY:
				paymentAmt = calculatePaymentAmt(premium.getFortnightlyPremium(), premium.getFortnightlyLhc(), rebateCalcReal);
				annualAmount = 26 * paymentAmt;
				break;
			case QUARTERLY:
				paymentAmt = calculatePaymentAmt(premium.getQuarterlyPremium(), premium.getQuarterlyLhc(), rebateCalcReal);
				annualAmount = 4 * paymentAmt;
				break;
			case HALF_YEARLY:
				paymentAmt = calculatePaymentAmt(premium.getHalfYearlyPremium(), premium.getHalfYearlyLhc(), rebateCalcReal);
				annualAmount = 2 * premium.getHalfYearlyPremium();
				break;
			case ANNUALLY:
				paymentAmt = calculatePaymentAmt(premium.getAnnualPremium(), premium.getAnnualLhc(), rebateCalcReal);
				annualAmount = paymentAmt;
				break;
			default:
				paymentAmt = calculatePaymentAmt(premium.getMonthlyPremium(), premium.getMonthlyLhc(), rebateCalcReal);
				annualAmount = 12 * paymentAmt;
		}
		data.put("health/application/paymentAmt", annualAmount);
		data.put("health/application/paymentFreq", paymentAmt);
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
	
	private double calculatePaymentAmt(double premium, double lhc, double rebateCalcWhole) {
		double rebateCalc = (rebateCalcWhole) * 0.01;
		PremiumCalculator premiumCalculator = new PremiumCalculator();
		premiumCalculator.setLhc(lhc);
		premiumCalculator.setLoading(request.loading);
		premiumCalculator.setMembership(request.membership);
		premiumCalculator.setBasePremium(premium);
		premiumCalculator.setRebateCalc(rebateCalc);
		
		return  premiumCalculator.getPremiumWithRebateAndLHC();
	}

}
