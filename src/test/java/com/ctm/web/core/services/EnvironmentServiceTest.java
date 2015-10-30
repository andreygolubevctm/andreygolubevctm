package com.ctm.services;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class EnvironmentServiceTest {

	@Test
	public void testEnvironment() throws Exception {
		EnvironmentService.setEnvironment("localhost");
		assertEquals(EnvironmentService.Environment.LOCALHOST, EnvironmentService.getEnvironment());
		EnvironmentService.setEnvironment("NXI");
		assertEquals(EnvironmentService.Environment.NXI, EnvironmentService.getEnvironment());
		EnvironmentService.setEnvironment("NXS");
		assertEquals(EnvironmentService.Environment.NXS, EnvironmentService.getEnvironment());
		EnvironmentService.setEnvironment("NXQ");
		assertEquals(EnvironmentService.Environment.NXQ, EnvironmentService.getEnvironment());
		EnvironmentService.setEnvironment("PRO");
		assertEquals(EnvironmentService.Environment.PRO, EnvironmentService.getEnvironment());
		EnvironmentService.setEnvironment("LOCALHOST");
		assertEquals(EnvironmentService.Environment.LOCALHOST, EnvironmentService.getEnvironment());
	}

	@Test
	public void testSetContextPath() {
		EnvironmentService.setContextPath("ctm-1234/");
		assertEquals("ctm-1234/", EnvironmentService.getContextPath());

		EnvironmentService.setContextPath("/ctm");
		assertEquals("ctm/", EnvironmentService.getContextPath());
	}

}