package com.ctm.services.health;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.GregorianCalendar;

import org.junit.Test;

import com.ctm.dao.StyleCodeDao;
import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPricePremiumRange;
import com.ctm.model.health.HealthPriceRequest;
import com.ctm.model.health.HealthPriceResult;
import com.ctm.model.health.Membership;

public class HealthPriceResultsServiceTest {
	
	private HealthPriceRequest healthPriceRequest;
	HealthPriceDao healthPriceDao = mock(HealthPriceDao.class);
	StyleCodeDao styleCodeDao = mock(StyleCodeDao.class);

	private void setUpHealthPriceService() throws DaoException {
		healthPriceRequest = new HealthPriceRequest();
		GregorianCalendar cal = new GregorianCalendar();
		cal.set(2014, 5, 1);

		healthPriceRequest.setPriceMinimum(0);
		healthPriceRequest.setPaymentFrequency("M");
		healthPriceRequest.setSearchDate("2014-10-20");
		healthPriceRequest.setState("QLD");
		healthPriceRequest.setMembership(Membership.FAMILY);
		healthPriceRequest.setProductType("Combined");
		healthPriceRequest.setExcessSel("4");
		healthPriceRequest.setPrivateHospital(true);
		healthPriceRequest.setPublicHospital(false);
		healthPriceRequest.setPreferences("'PrHospital','DentalGeneral','GeneralHealth','Hospital'");
		healthPriceRequest.setRebate(0);
		healthPriceRequest.setLoading(17);
		healthPriceRequest.setBrandFilter("0");
		healthPriceRequest.setIsSimples(false);
		healthPriceRequest.setOnResultsPage(true);
		healthPriceRequest.setRetrieveSavedResults(false);
		healthPriceRequest.setSavedTransactionId(0);
		healthPriceRequest.setDirectApplication(false);
		healthPriceRequest.setSelectedProductId("");
		healthPriceRequest.setProductTitle("");

		HealthPricePremiumRange healthPricePremiumRange = new HealthPricePremiumRange();
		when(healthPriceDao.getHealthPricePremiumRange(any(HealthPriceRequest.class))).thenReturn(healthPricePremiumRange);
	}
	
	@Test
	public void testShouldFetchMultipleResultWhenOnResultsPage() throws SQLException, DaoException {
		HealthPriceResultsService healthPriceResultsService = new HealthPriceResultsService(healthPriceDao);
		setUpHealthPriceService();

		ArrayList<HealthPriceResult> resultsFromDB = new ArrayList<HealthPriceResult>();
		when(healthPriceDao.fetchHealthResults(healthPriceRequest)).thenReturn(resultsFromDB );

		healthPriceResultsService.fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(0)).fetchSingleHealthResult(healthPriceRequest);
		verify(healthPriceDao, times(1)).fetchHealthResults(healthPriceRequest);
	}

	
	@Test
	public void testShouldFetchSingleResultWhenDirectApplication() throws SQLException, DaoException {
		HealthPriceResultsService healthPriceResultsService = new HealthPriceResultsService(healthPriceDao);
		setUpHealthPriceService();

		healthPriceRequest.setDirectApplication(true);
		healthPriceRequest.setSelectedProductId("12345678");

		HealthPriceResult resultFromDB= new HealthPriceResult();
		when(healthPriceDao.fetchSingleHealthResult(healthPriceRequest)).thenReturn(resultFromDB);

		healthPriceResultsService.fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(1)).fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(1)).fetchSingleHealthResult(healthPriceRequest);

		healthPriceRequest.setDirectApplication(false);
		healthPriceResultsService.fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(2)).fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(1)).fetchSingleHealthResult(healthPriceRequest);
	}
	
	@Test
	public void testShouldFetchSavedQuote() throws SQLException, DaoException {
		HealthPriceResultsService healthPriceResultsService = new HealthPriceResultsService(healthPriceDao);
		setUpHealthPriceService();

		healthPriceRequest.setRetrieveSavedResults(true);

		ArrayList<HealthPriceResult> resultsFromDB = new ArrayList<HealthPriceResult>();
		when(healthPriceDao.fetchSavedHealthResults(healthPriceRequest)).thenReturn(resultsFromDB);

		healthPriceResultsService.fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(1)).fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(1)).fetchSavedHealthResults(healthPriceRequest);

		healthPriceRequest.setRetrieveSavedResults(false);
		healthPriceResultsService.fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(2)).fetchHealthResults(healthPriceRequest);
		verify(healthPriceDao, times(1)).fetchSavedHealthResults(healthPriceRequest);
	}
}
