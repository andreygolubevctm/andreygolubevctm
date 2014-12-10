package com.ctm.services.health;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPriceResult;

public class HealthPriceDetailServiceTest {
	
	HealthPriceDao healthPriceDao = mock(HealthPriceDao.class);
	
	@Test
	public void testIsAlternatePriceDisabled() throws SQLException, DaoException {
		HealthPriceDetailService healthPriceDetailService = new HealthPriceDetailService(healthPriceDao);

		List<String> disabledFundsFromDB = new ArrayList<String>();
		disabledFundsFromDB.add("BUD");
		disabledFundsFromDB.add("AUF");
		disabledFundsFromDB.add("GMF");

		when(healthPriceDao.getDualPricingDisabledFunds()).thenReturn(disabledFundsFromDB);

		HealthPriceResult targetHealthResult= new HealthPriceResult();
		targetHealthResult.setFundCode("BUD");

		assertEquals("wrong fund dual pricing disabled", true, healthPriceDetailService.isAlternatePriceDisabled(targetHealthResult));
		verify(healthPriceDao, times(1)).getDualPricingDisabledFunds();

		targetHealthResult.setFundCode("FRA");
		assertEquals("wrong fund dual pricing disabled", false, healthPriceDetailService.isAlternatePriceDisabled(targetHealthResult));
		verify(healthPriceDao, times(2)).getDualPricingDisabledFunds();
	}

}
