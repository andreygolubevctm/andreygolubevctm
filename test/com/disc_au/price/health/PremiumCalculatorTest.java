package com.disc_au.price.health;

import static org.junit.Assert.assertEquals;

import java.sql.SQLException;
import java.text.ParseException;

import org.junit.Test;

import com.ctm.exceptions.DaoException;

public class PremiumCalculatorTest {

	@Test
	public void shouldSetupPriceMinium() throws SQLException, ParseException, DaoException {
		PremiumCalculator premiumCalculator = new PremiumCalculator();
		premiumCalculator.setRebate(0.2);
		double calculatedPremium = premiumCalculator.getPremiumWithoutRebate(80);
		assertEquals("wrong price minimum", 100.00, calculatedPremium, 1);
	}

	@Test
	public void shouldGetPremiumWithRebate() throws SQLException, ParseException, DaoException {
		PremiumCalculator premiumCalculator = new PremiumCalculator();
		premiumCalculator.setRebate(0.2);
		premiumCalculator.setBasePremium(100.00);
		double calculatedPremium = premiumCalculator.getLHCFreeValueDecimal().doubleValue();
		assertEquals("wrong price with rebate", 80.00, calculatedPremium, 1);
	}

}
