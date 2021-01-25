package com.ctm.web.health.quote.model.response;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by msmerdon on 15/1/21.
 */
public class PromotionTest {

	private final SpecialOffer specialOffer = new SpecialOffer();
	private final SpecialOffer awardScheme = new SpecialOffer();
	private final String hospitalPDF = "http://www.hospitalpdf.com/link";
	private final String extrasPDF = "http://www.extraspdf.com/link";
	private final String discountDescription = "<p>This is some discount description text</p>";
	private final String providerPhoneNumber = "1800 000 000";
	private final String providerDirectPhoneNumber = "13 00 00";

	@Test
	public void testPromotion() {
		Promotion promotion = new Promotion();
		promotion.setSpecialOffer(specialOffer);
		promotion.setAwardScheme(awardScheme);
		promotion.setHospitalPDF(hospitalPDF);
		promotion.setExtrasPDF(extrasPDF);
		promotion.setDiscountDescription(discountDescription);
		promotion.setProviderPhoneNumber(providerPhoneNumber);
		promotion.setProviderDirectPhoneNumber(providerDirectPhoneNumber);

		Assert.assertEquals(specialOffer, promotion.getSpecialOffer());
		Assert.assertEquals(awardScheme, promotion.getAwardScheme());
		Assert.assertEquals(hospitalPDF, promotion.getHospitalPDF());
		Assert.assertEquals(extrasPDF, promotion.getExtrasPDF());
		Assert.assertEquals(discountDescription, promotion.getDiscountDescription());
		Assert.assertEquals(providerPhoneNumber, promotion.getProviderPhoneNumber());
		Assert.assertEquals(providerDirectPhoneNumber, promotion.getProviderDirectPhoneNumber());
	}

	@Test
	public void testSpecialOffer() {
		final String offer = "This is a offer";
		final String terms = "This is the terms for said offer";
		specialOffer.setSummary(offer);
		specialOffer.setTerms(terms);
		Assert.assertEquals(offer, specialOffer.getSummary());
		Assert.assertEquals(terms, specialOffer.getTerms());
	}
}
