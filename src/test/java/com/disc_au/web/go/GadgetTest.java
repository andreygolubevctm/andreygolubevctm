package com.disc_au.web.go;
import com.ctm.web.core.web.go.Gadget;
import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class GadgetTest {

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
	}

}
