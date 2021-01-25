package com.ctm.web.health.model.form;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by msmerdon on 5/1/21.
 */
public class HealthQuoteTest {

	@Test
	public void testHospitalBenefitsSource() {
		HealthQuote quote = new HealthQuote();
		assertEquals("CTM", quote.getHospitalBenefitsSource());
		quote.setHospitalBenefitsSource("Barron Von Chickenpants");
		assertEquals("Barron Von Chickenpants", quote.getHospitalBenefitsSource());
	}

}
