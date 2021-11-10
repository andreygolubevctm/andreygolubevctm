package com.ctm.web.health.model;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

public class HealthFundTimeZoneTest {

	@Test
	public void testGetByCodeNull() {
		assertNull(HealthFundTimeZone.getByCode(null));
	}

	@Test
	public void testGetByCodeUHF() {
		assertEquals(HealthFundTimeZone.UHF, HealthFundTimeZone.getByCode("UHF"));
	}
}