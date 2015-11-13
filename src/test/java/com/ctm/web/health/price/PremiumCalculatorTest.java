package com.ctm.web.health.price;

import com.ctm.web.core.exceptions.DaoException;
import org.junit.Test;

import java.sql.SQLException;
import java.text.ParseException;

import static org.junit.Assert.assertEquals;

public class PremiumCalculatorTest {

	@Test
	public void shouldGetPremiumWithoutRebate() throws SQLException, ParseException, DaoException {
		PremiumCalculator premiumCalculator = new PremiumCalculator();
		premiumCalculator.setRebate(20);
		premiumCalculator.setBasePremium(100);
		double calculatedPremium = premiumCalculator.getPremiumWithoutRebate(80);
		assertEquals("wrong price minimum", 100.00, calculatedPremium, 1);
	}

	@Test
	public void shouldGetRebateAmount() throws SQLException, ParseException, DaoException {
		PremiumCalculator premiumCalculator = new PremiumCalculator();
		premiumCalculator.setRebate(20);
		premiumCalculator.setBasePremium(100);
		double calculatedPremium = premiumCalculator.getRebateAmount();
		assertEquals("wrong price minimum", 20.00, calculatedPremium, 1);
	}

	@Test
	public void shouldGetPremiumWithRebate() throws SQLException, ParseException, DaoException {
		PremiumCalculator premiumCalculator = new PremiumCalculator();
		premiumCalculator.setRebate(20);
		premiumCalculator.setBasePremium(100.00);
		double calculatedPremium = premiumCalculator.getLHCFreeValueDecimal().doubleValue();
		assertEquals("wrong price with rebate", 80.00, calculatedPremium, 1);
	}

}
