package com.ctm.web.health.model.form;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by msmerdon on 15/1/21.
 */
public class FundDataTest {

	private final String hospitalPDF = "http://www.hospitalpdf.com/link";
	private final String extrasPDF = "http://www.extraspdf.com/link";
	private final String providerPhoneNumber = "1800 000 000";
	private final String providerDirectPhoneNumber = "13 00 00";

	@Test
	public void testObject() {
		FundData fundData = new FundData();
		fundData.setHospitalPDF(hospitalPDF);
		fundData.setExtrasPDF(extrasPDF);
		fundData.setProviderPhoneNumber(providerPhoneNumber);
		fundData.setProviderDirectPhoneNumber(providerDirectPhoneNumber);

		assertEquals(hospitalPDF, fundData.getHospitalPDF());
		assertEquals(extrasPDF, fundData.getExtrasPDF());
		assertEquals(providerPhoneNumber, fundData.getProviderPhoneNumber());
		assertEquals(providerDirectPhoneNumber, fundData.getProviderDirectPhoneNumber());
	}
}
