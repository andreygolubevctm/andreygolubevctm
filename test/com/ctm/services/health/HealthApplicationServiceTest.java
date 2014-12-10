package com.ctm.services.health;

import java.sql.SQLException;

import org.junit.Before;
import org.junit.Test;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.Frequency;
import com.ctm.model.health.HealthPricePremium;
import com.disc_au.web.go.Data;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;


public class HealthApplicationServiceTest {
	
		private HealthApplicationService healthApplicationService;
		private Data data = new Data();
		private double rebateMultiplierCurrent = 0.968;
		private HealthPriceDao healthPriceDao;

		@Before
		public void setup() throws DaoException {
			healthPriceDao = mock(HealthPriceDao.class);
			healthApplicationService = new HealthApplicationService(healthPriceDao );
			data.put("health/application/productId", "PHIO-HEALTH-545038");
			data.put("health/payment/details/frequency", Frequency.MONTHLY.getDescription());
			data.put("health/situation/healthCvr", "S");
			data.put("health/payment/details/start", "27/11/2014");
			data.put("health/application/provider", "AUF");
			HealthPricePremium premiums = new HealthPricePremium();
			premiums.setMonthlyLhc(86.15);
			premiums.setMonthlyPremium(148.2);
			
			HealthPricePremium discPremiums = new HealthPricePremium();
			discPremiums.setMonthlyLhc(86.15);
			discPremiums.setMonthlyPremium(142.3);
			
			when(healthPriceDao.getPremiumAndLhc("545038", false)).thenReturn(premiums );
			when(healthPriceDao.getPremiumAndLhc("545038", true)).thenReturn(discPremiums );
		}
		
		@Test
		public void testShouldGetAmount() throws SQLException, DaoException {
			data.put("health/loading", "0");
			data.put("health/rebate", "0");
			healthApplicationService.calculatePremiums(data, rebateMultiplierCurrent);
			String paymentAmtResult = (String) data.get("health/application/paymentAmt");
			String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
			assertEquals("142.3" ,paymentFreqResult);
			assertEquals("1707.6000000000001" ,paymentAmtResult);
		}

		@Test
		public void testShouldGetAmountWithRebate() throws SQLException, DaoException {
			data.put("health/loading", "0");
			data.put("health/rebate", "30");
			
			healthApplicationService.calculatePremiums(data, rebateMultiplierCurrent);
			String paymentAmtResult = (String) data.get("health/application/paymentAmt");
			String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
			assertEquals("100.98" ,paymentFreqResult);
			assertEquals("1211.76" ,paymentAmtResult);
		}
		
		@Test
		public void testShouldGetAmountWithLHC() throws SQLException, DaoException {
			data.put("health/loading", "34");
			data.put("health/rebate", "0");
			healthApplicationService.calculatePremiums(data, rebateMultiplierCurrent);
			String paymentAmtResult = (String) data.get("health/application/paymentAmt");
			String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
			assertEquals("171.59" ,paymentFreqResult);
			assertEquals("2059.08" ,paymentAmtResult);
		}
		

		@Test
		public void testShouldGetAmountWithLHCandRebate() throws SQLException, DaoException {
			data.put("health/loading", "34");
			data.put("health/rebate", "30");
			healthApplicationService.calculatePremiums(data, rebateMultiplierCurrent);
			String paymentAmtResult = (String) data.get("health/application/paymentAmt");
			String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
			assertEquals("1563.2400000000002" ,paymentAmtResult);
			assertEquals("130.27" ,paymentFreqResult);
		}
		
		@Test
		public void testShouldGetAmountWithLHCandRebateNib() throws SQLException, DaoException {
			data.put("health/application/provider", "NIB");
			data.put("health/application/productId", "PHIO-HEALTH-563234");
			
			HealthPricePremium premiums = new HealthPricePremium();
			premiums.setMonthlyLhc(82.68);
			premiums.setMonthlyPremium(137.32);
			
			HealthPricePremium discPremiums = new HealthPricePremium();
			discPremiums.setMonthlyLhc(82.68);
			discPremiums.setMonthlyPremium(131.83);
			
			when(healthPriceDao.getPremiumAndLhc("563234", false)).thenReturn(premiums );
			when(healthPriceDao.getPremiumAndLhc("563234", true)).thenReturn(discPremiums );
			
			data.put("health/loading", "34");
			data.put("health/rebate", "30");
			
			//credit
			data.put("health/payment/details/type", "cc");
			
			healthApplicationService.calculatePremiums(data, rebateMultiplierCurrent);
			String paymentAmtResult = (String) data.get("health/application/paymentAmt");
			String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
			assertEquals("1506.6" ,paymentAmtResult);
			assertEquals("125.55" ,paymentFreqResult);
			
			//bank
			data.put("health/payment/details/type", "ba");
			healthApplicationService.calculatePremiums(data, rebateMultiplierCurrent);
			paymentAmtResult = (String) data.get("health/application/paymentAmt");
			paymentFreqResult =  (String) data.get("health/application/paymentFreq");
			assertEquals("1459.92" ,paymentAmtResult);
			assertEquals("121.66" ,paymentFreqResult);
			
		}



}
