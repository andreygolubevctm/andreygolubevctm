package com.ctm.services.health;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.sql.SQLException;
import java.util.Date;
import java.util.GregorianCalendar;

import org.junit.Test;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPricePremiumRange;
import com.ctm.model.health.HealthPriceRequest;


public class HealthPriceServiceTest {

	HealthPriceDao healthPriceDao = mock(HealthPriceDao.class);

	@Test
	public void testShouldRoundPremiumToNearestFive() throws SQLException, DaoException {
		HealthPriceService healthPriceService = new HealthPriceService(healthPriceDao);

		healthPriceService.setChangeoverDate(new Date());
		healthPriceService.setSearchDate("2014-01-01");

		HealthPricePremiumRange healthPricePremiumRange = new HealthPricePremiumRange();
		healthPricePremiumRange.setMaxFortnightlyPremium(103.50);
		healthPricePremiumRange.setMinFortnightlyPremium(0);

		healthPricePremiumRange.setMaxMonthlyPremium(507.50);
		healthPricePremiumRange.setMinMonthlyPremium(0);

		healthPricePremiumRange.setMaxYearlyPremium(5007.20);
		healthPricePremiumRange.setMinYearlyPremium(0);

		when(healthPriceDao.getHealthPricePremiumRange(any(HealthPriceRequest.class))).thenReturn(healthPricePremiumRange);
		healthPriceService.setup();

		assertEquals("wrong price with rebate", 100.00, healthPriceService.getHealthPricePremiumRange().getMaxFortnightlyPremium(), 1);
		assertEquals("wrong price with rebate", 505.00, healthPriceService.getHealthPricePremiumRange().getMaxMonthlyPremium(), 1);
		assertEquals("wrong price with rebate", 5005.00, healthPriceService.getHealthPricePremiumRange().getMaxYearlyPremium(), 1);

	}

	@Test
	public void testShouldSetRebate() throws SQLException, DaoException {
		HealthPriceService healthPriceService = new HealthPriceService(healthPriceDao);

		setUpHealthPriceService(healthPriceService);
		healthPriceService.setup();

		assertEquals("wrong price with rebate", 60.0, healthPriceService.getHealthPricePremiumRange().getMaxFortnightlyPremium(), 1);
		assertEquals("wrong price with rebate", 90.44, healthPriceService.getHealthPricePremiumRange().getMaxFortnightlyPremiumBase(), 1);

		assertEquals("wrong price with rebate", 520.0, healthPriceService.getHealthPricePremiumRange().getMaxMonthlyPremium(), 1);
		assertEquals("wrong price with rebate", 734.74, healthPriceService.getHealthPricePremiumRange().getMaxMonthlyPremiumBase(), 1);

		assertEquals("wrong price with rebate", 1665.0, healthPriceService.getHealthPricePremiumRange().getMaxYearlyPremium(), 1);
		assertEquals("wrong price with rebate", 2351.44, healthPriceService.getHealthPricePremiumRange().getMaxYearlyPremiumBase(), 1);

	}

	private void setUpHealthPriceService(
			HealthPriceService healthPriceService) throws DaoException {
		GregorianCalendar cal = new GregorianCalendar();
		cal.set(2014, 05, 01);
		healthPriceService.setChangeoverDate(cal.getTime());
		healthPriceService.setSearchDate("13/06/2014");
		healthPriceService.setRebateChangeover(0.0);
		healthPriceService.setRebate(30.0);
		healthPriceService.setRebateMultiplierCurrent(0.968);


		HealthPricePremiumRange healthPricePremiumRange = new HealthPricePremiumRange();
		healthPricePremiumRange.setMaxFortnightlyPremium(90.44);
		healthPricePremiumRange.setMinFortnightlyPremium(0);

		healthPricePremiumRange.setMaxMonthlyPremium(734.74);
		healthPricePremiumRange.setMinMonthlyPremium(0);

		healthPricePremiumRange.setMinYearlyPremium(0);
		healthPricePremiumRange.setMaxYearlyPremium(2351.44);

		when(healthPriceDao.getHealthPricePremiumRange(any(HealthPriceRequest.class))).thenReturn(healthPricePremiumRange);
	}

	@Test
	public void testShouldGetMinimum() throws SQLException, DaoException {
		HealthPriceService healthPriceService = new HealthPriceService(healthPriceDao);
		setUpHealthPriceService(healthPriceService);
		healthPriceService.setPriceMinimum(100);
		healthPriceService.setPaymentFrequency("F");
		healthPriceService.setOnResultsPage(true);
		healthPriceService.setup();

		assertEquals("wrong price with rebate", 90.44, healthPriceService.getHealthPriceRequest().getPriceMinimum(), 1);

		healthPriceService.setPriceMinimum(100);
		healthPriceService.setPaymentFrequency("Q");
		healthPriceService.setup();
		assertEquals("wrong price with rebate", 0.00, healthPriceService.getHealthPriceRequest().getPriceMinimum(), 1);
	}

	@Test
	public void testShouldSetSearchDate() throws SQLException, DaoException {
		HealthPriceService healthPriceService = new HealthPriceService(healthPriceDao);

		setUpHealthPriceService(healthPriceService);
		healthPriceService.setSearchDate("18/08/2014");
		healthPriceService.setup();

		assertEquals("wrong date", "2014-08-18", healthPriceService.getHealthPriceRequest().getSearchDate());

	}

}
