package com.ctm.web.core.web.go;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.junit.Assert.assertEquals;


public class GadgetTest {
	private static final Logger LOGGER = LoggerFactory.getLogger(GadgetTest.class);

	@Test
	public void testShouldRoundCurrencyHalfUp() {
		assertEquals(Gadget.formatCurrency("5.005", true, false) , "$5.01");
		assertEquals(Gadget.formatCurrency("5.005", false, false) , "5.01");
		assertEquals(Gadget.formatCurrency("6.005", true, false) , "$6.01");
		assertEquals(Gadget.formatCurrency("6.005", false, false) , "6.01");

		assertEquals(Gadget.formatCurrency("5.0045", true, false) , "$5.00");
		assertEquals(Gadget.formatCurrency("5.0045", false, false) , "5.00");
		assertEquals(Gadget.formatCurrency("6.0045", true, false) , "$6.00");
		assertEquals(Gadget.formatCurrency("6.0045", false, false) , "6.00");

		String removeCrlf = String.format("this %s is a %s test %s bro!","\r","\r\n", "\n");
		assertEquals(Gadget.replaceAll(removeCrlf, "\r|\n", ""), "this  is a  test  bro!");
	}

}
