package com.ctm.web.health.model.results;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by msmerdon on 15/1/21.
 */
public class PromoTest {

	private final String promoText = "<p>This is some promo text</p>";
	private final String hospitalPDF = "http://www.hospitalpdf.com/link";
	private final String extrasPDF = "http://www.extraspdf.com/link";
	private final String discountText = "<p>This is some discount text</p>";
	private final String providerPhoneNumber = "1800 000 000";
	private final String providerDirectPhoneNumber = "13 00 00";

	@Test
	public void testObject() {
		Promo promo = new Promo();
		promo.setPromoText(promoText);
		promo.setHospitalPDF(hospitalPDF);
		promo.setExtrasPDF(extrasPDF);
		promo.setDiscountText(discountText);
		promo.setProviderPhoneNumber(providerPhoneNumber);
		promo.setProviderDirectPhoneNumber(providerDirectPhoneNumber);

		assertEquals(promoText, promo.getPromoText());
		assertEquals(hospitalPDF, promo.getHospitalPDF());
		assertEquals(extrasPDF, promo.getExtrasPDF());
		assertEquals(discountText, promo.getDiscountText());
		assertEquals(providerPhoneNumber, promo.getProviderPhoneNumber());
		assertEquals(providerDirectPhoneNumber, promo.getProviderDirectPhoneNumber());
	}
}
