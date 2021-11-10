package com.ctm.web.health.model.form;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class ApplicationTest {

	@Test
	public void testApplication_getUhf() {
		final Uhf uhf = new Uhf();
		uhf.setEligibility("FORM");
		final Application application = new Application();
		application.setUhf(uhf);
		assertEquals(uhf.getEligibility(), application.getUhf().getEligibility());

	}

}