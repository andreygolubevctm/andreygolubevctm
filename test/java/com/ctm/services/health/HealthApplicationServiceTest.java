package com.ctm.services.health;

import java.sql.SQLException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;

import com.ctm.model.health.Frequency;
import com.ctm.services.RequestService;
import com.ctm.utils.FormDateUtils;

import org.junit.Before;
import org.junit.Test;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPricePremium;
import com.ctm.model.health.Frequency;
import com.disc_au.web.go.Data;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;


public class HealthApplicationServiceTest {

	private static final String PREFIX = "health";
	private HealthApplicationService healthApplicationService;
	private Data data = new Data();
	private HealthPriceDao healthPriceDao;
	private HttpServletRequest request = mock(HttpServletRequest.class);
	private Date changeOverDate;

	@Before
	public void setup() throws Exception {
		RequestService requestService = mock(RequestService.class);
		healthPriceDao = mock(HealthPriceDao.class);
		data.put(PREFIX + "/application/productId", "PHIO-HEALTH-545038");
		data.put(PREFIX + "/payment/details/frequency", Frequency.MONTHLY.getDescription());
		data.put(PREFIX + "/situation/healthCvr", "SM");
		data.put(PREFIX + "/payment/details/start", "27/11/2014");
		data.put(PREFIX + "/application/provider", "AUF");
		HealthPricePremium premiums = new HealthPricePremium();
		premiums.setMonthlyLhc(86.15);
		premiums.setMonthlyPremium(148.2);

		HealthPricePremium discPremiums = new HealthPricePremium();
		discPremiums.setMonthlyLhc(86.15);
		discPremiums.setMonthlyPremium(142.3);

		when(healthPriceDao.getPremiumAndLhc("545038", false)).thenReturn(premiums );
		when(healthPriceDao.getPremiumAndLhc("545038", true)).thenReturn(discPremiums );

		healthApplicationService = new HealthApplicationService(healthPriceDao);
		healthApplicationService.setRequestService(requestService);

		setChangeOverDate();
	}

	@Test
	public void testShouldGetAmount() throws SQLException, Exception {
		data.put("health/loading", "0");
		data.put("health/rebate", "0");
		Date changeOverDate = new Date();
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1707.6000000000001" ,paymentAmtResult);
		assertEquals("142.3" ,paymentFreqResult);
	}

	@Test
	public void testShouldGetAmountWithRebate() throws SQLException, Exception, JspException {
		data.put("health/loading", "0");
		data.put("health/rebate", "29.04");

		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("100.98" ,paymentFreqResult);
		assertEquals("1211.76" ,paymentAmtResult);
	}

	@Test
	public void testShouldGetAmountWithLHC() throws SQLException, Exception, JspException {
		data.put("health/loading", "34");
		data.put("health/rebate", "0");
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("171.59" ,paymentFreqResult);
		assertEquals("2059.08" ,paymentAmtResult);
	}


	@Test
	public void testShouldGetAmountWithLHCandRebate() throws SQLException, Exception {
		data.put("health/loading", "34");
		data.put("health/rebate", "29.04");
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1563.2400000000002" ,paymentAmtResult);
		assertEquals("130.27" ,paymentFreqResult);
	}

	@Test
	public void testShouldGetAmountWithLHCandRebateNib() throws SQLException, Exception {
		setupNib();
		//credit
		data.put("health/payment/details/type", "cc");

		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1506.6" ,paymentAmtResult);
		assertEquals("125.55" ,paymentFreqResult);
	}


	@Test
	public void testShouldGetAmountWithLHCandRebateNibBank() throws SQLException, Exception {
		setupNib();

		//bank
		data.put("health/payment/details/type", "ba");
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult = (String) data.get("health/application/paymentFreq");
		assertEquals("1459.92" ,paymentAmtResult);
		assertEquals("121.66" ,paymentFreqResult);

	}

	private void setupNib() throws DaoException, JspException {
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
		data.put("health/rebate", "29.04");

		//credit
		data.put("health/payment/details/type", "cc");

		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1506.6" ,paymentAmtResult);
		assertEquals("125.55" ,paymentFreqResult);

		//bank
		data.put("health/payment/details/type", "ba");
		data.put(PREFIX + "/payment/details/frequency", Frequency.MONTHLY.getDescription());
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		paymentAmtResult = (String) data.get("health/application/paymentAmt");
		paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1459.92" ,paymentAmtResult);
		assertEquals("121.66" ,paymentFreqResult);
		data.put(PREFIX + "/payment/details/frequency", Frequency.MONTHLY.getDescription());

	}

	private void setChangeOverDate() {
		String changeOverDateString = "01/04/2015";
		this.changeOverDate = FormDateUtils.parseDateFromForm(changeOverDateString);
	}

}
