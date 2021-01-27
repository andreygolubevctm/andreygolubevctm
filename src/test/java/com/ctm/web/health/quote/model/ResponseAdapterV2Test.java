package com.ctm.web.health.quote.model;

import com.ctm.web.health.model.form.Insured;
import com.ctm.web.health.model.results.Promo;
import com.ctm.web.health.quote.model.response.Promotion;
import com.ctm.web.health.quote.model.response.SpecialOffer;
import org.junit.Assert;
import org.junit.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class ResponseAdapterV2Test {

    private static DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final String JOHNS_BIRTHDAY = "25/07/1983";
    private static final String LHC_EXEMPT_BIRTHDATE = "01/07/1934";

    private final SpecialOffer specialOffer = new SpecialOffer();
    private final String specialOfferCopy = "This is the special offer copy";
    private final String specialOfferTerms = "This is the terms for the special offer";
    private final SpecialOffer awardScheme = new SpecialOffer();
    private final String hospitalPDF = "http://www.hospitalpdf.com/link";
    private final String extrasPDF = "http://www.extraspdf.com/link";
    private final String discountDescription = "<p>This is some discount description text</p>";
    private final String providerPhoneNumber = "1800 000 000";
    private final String providerDirectPhoneNumber = "13 00 00";

    @Test
    public void testCalculateRebateValueWithEmptyRebate() {
        assertEquals(new BigDecimal(25), ResponseAdapterV2.calculateRebateValue(Optional.empty(), new BigDecimal(100), new BigDecimal(25)));
    }

    @Test
    public void testCalculateRebateValueWithRebate() {
        assertEquals(new BigDecimal("30.00"), ResponseAdapterV2.calculateRebateValue(Optional.of(BigDecimal.valueOf(30)), new BigDecimal(100), new BigDecimal(25)));
    }

    @Test
    public void givenInsured_isOldEnoughForLHC_andWantsHospitalCover_thenInsuredIsAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = true;
        testInsured.setDob(JOHNS_BIRTHDAY);

        assertTrue(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    @Test
    public void givenInsured_isOldEnoughForLHC_andWantsExtrasCoverOnly_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = false;
        testInsured.setDob(JOHNS_BIRTHDAY);

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    @Test
    public void givenInsured_whenHasNoApplicableLHCCoverDays_andWantsExtrasCoverOnly_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = false;
        testInsured.setDob(LocalDate.now().plusDays(1).format(formatter));

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    @Test
    public void givenInsured_whenHasNoApplicableLHCCoverDays_andWantsHospitalCover_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = true;
        testInsured.setDob(LocalDate.now().plusDays(1).format(formatter));

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }


    @Test
    public void givenInsured_isTooOldForLHC_andWantsExtrasCoverOnly_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = false;
        testInsured.setDob(LHC_EXEMPT_BIRTHDATE);

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    @Test
    public void givenInsured_isTooOldForLHC_andWantsHospitalCover_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = true;
        testInsured.setDob(LHC_EXEMPT_BIRTHDATE);

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    @Test
    public void testCreatePromo() {
    	final String brandCode = "ctm";
    	final String staticBranch = "feature/CTM-666";
    	final boolean isSimplesUser = true;
        Promotion promotion = new Promotion();
        specialOffer.setSummary(specialOfferCopy);
        specialOffer.setTerms(specialOfferTerms);
        promotion.setSpecialOffer(specialOffer);
        promotion.setAwardScheme(awardScheme);
        promotion.setHospitalPDF(hospitalPDF);
        promotion.setExtrasPDF(extrasPDF);
        promotion.setDiscountDescription(discountDescription);
        promotion.setProviderPhoneNumber(providerPhoneNumber);
        promotion.setProviderDirectPhoneNumber(providerDirectPhoneNumber);

        Promo calculatedPromo = ResponseAdapterV2.createPromo(promotion, staticBranch, isSimplesUser, brandCode);

		Promo promo = new Promo();
		promo.setProviderDirectPhoneNumber(providerDirectPhoneNumber);
		promo.setProviderPhoneNumber(providerPhoneNumber);
		promo.setDiscountText(discountDescription);
		promo.setHospitalPDF(hospitalPDF);
		promo.setExtrasPDF(extrasPDF);
		promo.setPromoText("This is the special offer copy<p><a class=\"dialogPop\" data-content=\"This is the terms for the special offer\" title=\"Terms and Conditions\" data-class=\"results-promo-modal\">^ Terms and Conditions</a></p>");

		assertEquals(calculatedPromo.getDiscountText(), promo.getDiscountText());
		assertEquals(calculatedPromo.getExtrasPDF(), promo.getExtrasPDF());
		assertEquals(calculatedPromo.getHospitalPDF(), promo.getHospitalPDF());
		assertEquals(calculatedPromo.getPromoText(), promo.getPromoText());
		assertEquals(calculatedPromo.getProviderPhoneNumber(), promo.getProviderPhoneNumber());
		assertEquals(calculatedPromo.getProviderDirectPhoneNumber(), promo.getProviderDirectPhoneNumber());
    }
}