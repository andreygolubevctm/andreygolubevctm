package com.ctm.web.health.quote.model;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.providers.model.IncomingQuotesResponse;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.form.HealthCover;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Insured;
import com.ctm.web.health.model.results.Promo;
import com.ctm.web.health.quote.model.response.HealthQuote;
import com.ctm.web.health.quote.model.response.HealthResponseV2;
import com.ctm.web.health.quote.model.response.Info;
import com.ctm.web.health.quote.model.response.Premium;
import com.ctm.web.health.quote.model.response.Promotion;
import com.ctm.web.health.quote.model.response.SpecialOffer;
import com.fasterxml.jackson.databind.JsonNode;
import org.junit.Test;
import org.mockito.Mockito;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Mockito.when;

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

    @Test
    public void TestGetPaymentType() {
        assertEquals("BankAccount", ResponseAdapterV2.getPaymentType(PaymentType.BANK));
        assertEquals("CreditCard", ResponseAdapterV2.getPaymentType(PaymentType.CREDIT));
        assertEquals("Invoice", ResponseAdapterV2.getPaymentType(PaymentType.INVOICE));
    }

    @Test
    public void testFormatCurrency() {
        assertEquals("14.00", ResponseAdapterV2.formatCurrency(BigDecimal.valueOf(14l), false, false));
        assertEquals("$14.00", ResponseAdapterV2.formatCurrency(BigDecimal.valueOf(14l), true, false));
    }

    @Test
    public void testAdaptUnavailableResponse() {
        // Given
        HealthRequest healthRequest = Mockito.mock(HealthRequest.class);
        HealthResponseV2 healthResponseV2 = Mockito.mock(HealthResponseV2.class);
        IncomingQuotesResponse.Payload<HealthQuote> payload = (IncomingQuotesResponse.Payload<HealthQuote>) Mockito.mock(IncomingQuotesResponse.Payload.class);
        when(healthResponseV2.getPayload()).thenReturn(payload);
        Content content = Mockito.mock(Content.class);
        String brandCode = "CTM";
        // When
        ResponseAdapterModel response = ResponseAdapterV2.adapt(healthRequest, healthResponseV2, content, brandCode);
        // Then
        assertNotNull(response);
        assertTrue(response.isHasPriceChanged());
        assertFalse(response.getPremiumRange().isPresent());
    }

    @Test
    public void testAdaptOnSingleQuote() {
        // Given
        HealthRequest healthRequest = Mockito.mock(HealthRequest.class);
        HealthResponseV2 healthResponseV2 = Mockito.mock(HealthResponseV2.class);
        IncomingQuotesResponse.Payload<HealthQuote> payload = (IncomingQuotesResponse.Payload<HealthQuote>) Mockito.mock(IncomingQuotesResponse.Payload.class);
        com.ctm.web.health.model.form.HealthQuote healthQuote = Mockito.mock(com.ctm.web.health.model.form.HealthQuote.class);
        when(healthQuote.getApplyDiscounts()).thenReturn("Y");
        HealthCover cover = new HealthCover();
        Insured insured = new Insured();
        insured.setDob("01/01/1990");
        cover.setPartner(insured);
        cover.setPrimary(insured);
        when(healthQuote.getHealthCover()).thenReturn(cover);
        when(healthRequest.getQuote()).thenReturn(healthQuote);
        HealthQuote quote = new HealthQuote();
        quote.setAvailable(true);
        quote.setPromotion(new Promotion());
        quote.setPremium(new Premium());
        JsonNode mockJson = Mockito.mock(JsonNode.class);
        quote.setCustom(mockJson);
        quote.setHospital(mockJson);
        quote.setExtras(mockJson);
        when(mockJson.has("hasSpecialFeatures")).thenReturn(true);
        quote.setAmbulance(mockJson);
        quote.setAccident(mockJson);
        Info info = new Info();
        Map<String, String> otherInfo = new HashMap<>();
        info.setOtherInfoProperties(otherInfo);
        quote.setInfo(info);
        List<HealthQuote> quoteList = Collections.singletonList(quote);
        when(payload.getQuotes()).thenReturn(quoteList);
        when(healthResponseV2.getPayload()).thenReturn(payload);
        Content content = Mockito.mock(Content.class);
        when(content.getContentValue()).thenReturn("Y");
        String brandCode = "CTM";
        // When
        ResponseAdapterModel response = ResponseAdapterV2.adapt(healthRequest, healthResponseV2, content, brandCode);
        // Then
        assertNotNull(response);
        assertEquals(1, response.getResults().size() );
        assertEquals(AvailableType.Y, response.getResults().get(0).getAvailable());
    }

    @Test
    public void testAdaptOnSingleQuoteWithPaymentTypePremium() {
        // Given
        HealthRequest healthRequest = Mockito.mock(HealthRequest.class);
        HealthResponseV2 healthResponseV2 = Mockito.mock(HealthResponseV2.class);
        IncomingQuotesResponse.Payload<HealthQuote> payload = (IncomingQuotesResponse.Payload<HealthQuote>) Mockito.mock(IncomingQuotesResponse.Payload.class);
        com.ctm.web.health.model.form.HealthQuote healthQuote = Mockito.mock(com.ctm.web.health.model.form.HealthQuote.class);
        when(healthQuote.getApplyDiscounts()).thenReturn("Y");
        HealthCover cover = new HealthCover();
        Insured insured = new Insured();
        insured.setDob("01/01/2002");
        cover.setPartner(insured);
        cover.setPrimary(insured);
        when(healthQuote.getHealthCover()).thenReturn(cover);
        when(healthRequest.getQuote()).thenReturn(healthQuote);
        HealthQuote quote = new HealthQuote();
        quote.setAvailable(true);
        quote.setPromotion(new Promotion());
        quote.setPremium(null);
        quote.setPaymentTypePremiums(new HashMap<>());
        Map<PaymentType, Premium> altPremiums = new HashMap<>();
        altPremiums.put(PaymentType.BANK, new Premium());
        quote.setPaymentTypeAltPremiums(altPremiums);
        JsonNode mockJson = Mockito.mock(JsonNode.class);
        quote.setCustom(mockJson);
        quote.setHospital(mockJson);
        quote.setExtras(mockJson);
        when(mockJson.has("hasSpecialFeatures")).thenReturn(true);
        quote.setAmbulance(mockJson);
        quote.setAccident(mockJson);
        Info info = new Info();
        Map<String, String> otherInfo = new HashMap<>();
        info.setOtherInfoProperties(otherInfo);
        quote.setInfo(info);
        List<HealthQuote> quoteList = Collections.singletonList(quote);
        when(payload.getQuotes()).thenReturn(quoteList);
        when(healthResponseV2.getPayload()).thenReturn(payload);
        Content content = Mockito.mock(Content.class);
        when(content.getContentValue()).thenReturn("Y");
        String brandCode = "CTM";
        // When
        ResponseAdapterModel response = ResponseAdapterV2.adapt(healthRequest, healthResponseV2, content, brandCode);
        // Then
        assertNotNull(response);
        assertEquals(1, response.getResults().size() );
        assertEquals(AvailableType.Y, response.getResults().get(0).getAvailable());
    }

    @Test
    public void testAdaptOnSingleQuoteWithPaymentTypePremiumNullPaymentAtlPremiums() {
        // Given
        HealthRequest healthRequest = Mockito.mock(HealthRequest.class);
        HealthResponseV2 healthResponseV2 = Mockito.mock(HealthResponseV2.class);
        IncomingQuotesResponse.Payload<HealthQuote> payload = (IncomingQuotesResponse.Payload<HealthQuote>) Mockito.mock(IncomingQuotesResponse.Payload.class);
        com.ctm.web.health.model.form.HealthQuote healthQuote = Mockito.mock(com.ctm.web.health.model.form.HealthQuote.class);
        when(healthQuote.getApplyDiscounts()).thenReturn("Y");
        HealthCover cover = new HealthCover();
        Insured insured = new Insured();
        insured.setDob("01/01/2002");
        cover.setPartner(insured);
        cover.setPrimary(insured);
        when(healthQuote.getHealthCover()).thenReturn(cover);
        when(healthRequest.getQuote()).thenReturn(healthQuote);
        HealthQuote quote = new HealthQuote();
        quote.setAvailable(true);
        quote.setPromotion(new Promotion());
        quote.setPremium(null);
        quote.setPaymentTypePremiums(new HashMap<>());
        Map<PaymentType, Premium> altPremiums = new HashMap<>();
        altPremiums.put(PaymentType.BANK, new Premium());
        quote.setPaymentTypeAltPremiums(null);
        JsonNode mockJson = Mockito.mock(JsonNode.class);
        quote.setCustom(mockJson);
        quote.setHospital(mockJson);
        quote.setExtras(mockJson);
        when(mockJson.has("hasSpecialFeatures")).thenReturn(true);
        quote.setAmbulance(mockJson);
        quote.setAccident(mockJson);
        Info info = new Info();
        Map<String, String> otherInfo = new HashMap<>();
        info.setOtherInfoProperties(otherInfo);
        quote.setInfo(info);
        List<HealthQuote> quoteList = Collections.singletonList(quote);
        when(payload.getQuotes()).thenReturn(quoteList);
        when(healthResponseV2.getPayload()).thenReturn(payload);
        Content content = Mockito.mock(Content.class);
        when(content.getContentValue()).thenReturn("Y");
        String brandCode = "CTM";
        // When
        ResponseAdapterModel response = ResponseAdapterV2.adapt(healthRequest, healthResponseV2, content, brandCode);
        // Then
        assertNotNull(response);
        assertEquals(1, response.getResults().size() );
        assertEquals(AvailableType.Y, response.getResults().get(0).getAvailable());
    }
}