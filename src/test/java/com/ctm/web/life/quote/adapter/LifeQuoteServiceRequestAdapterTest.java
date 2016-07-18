package com.ctm.web.life.quote.adapter;

import com.ctm.life.quote.model.request.LifeQuoteRequest;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.life.form.model.*;
import org.junit.Before;
import org.junit.Test;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertEquals;


public class LifeQuoteServiceRequestAdapterTest {

    private static final String EMAIL = "preload.testing@comparethemarket.com.au";
    private static final String PRIMARY_FIRSTNAME = "Joe";
    private static final String PARTNER_SURNAME = "Bloggs";

    private LifeQuoteServiceRequestAdapter requestAdapter;

    @Before
    public void setUp() throws Exception {
         requestAdapter = new LifeQuoteServiceRequestAdapter();
    }

    @Test
    public void adaptTestDifferentInsurance() throws Exception {
        LifeQuoteWebRequest request = getLifeQuoteWebRequest();
        request.getLife().getPrimary().getInsurance().setPartner(YesNo.Y);
        request.getLife().getPrimary().getInsurance().setSamecover(YesNo.N);
        Insurance insurance = new Insurance();
        request.getLife().getPartner().setInsurance(insurance);
        final LifeQuoteRequest result = requestAdapter.adapt(request);

        assertEquals(EMAIL, result.getContactDetails().getEmail());
        assertEquals(PRIMARY_FIRSTNAME , result.getApplicants().getPrimary().getFirstName());
        assertEquals(PARTNER_SURNAME , result.getApplicants().getPartner().get().getLastName());
    }

    private LifeQuoteWebRequest getLifeQuoteWebRequest() {
        LifeQuoteWebRequest request = new LifeQuoteWebRequest();
        request.setTransactionId(2725461L);
        LifeQuote life = new LifeQuote();
        Applicant primary = new Applicant();
        primary.setGender(Gender.M);
        primary.setSmoker(YesNo.N);

        Insurance insurance = new Insurance();
        insurance.setPartner(YesNo.Y);
        insurance.setSamecover(YesNo.Y);
        insurance.setFrequency("M");
        primary.setInsurance(insurance);
        primary.setFirstName(PRIMARY_FIRSTNAME);
        life.setPrimary(primary);

        Applicant partner = new Applicant();
        partner.setSmoker(YesNo.N);
        partner.setGender(Gender.F);
        partner.setLastname(PARTNER_SURNAME);
        life.setPartner(partner);
        ContactDetails contactDetails = new ContactDetails();
        contactDetails.setEmail(EMAIL);
        life.setContactDetails(contactDetails);
        request.setLife(life);
        return request;
    }

    @Test
    public void adaptNoPartnerTest() throws Exception {
        LifeQuoteWebRequest request = getLifeQuoteWebRequest();
        request.getLife().getPrimary().getInsurance().setPartner(YesNo.N);

        final LifeQuoteRequest result = requestAdapter.adapt(request);
        assertFalse(result.getApplicants().getPartner().isPresent());
        assertEquals(EMAIL, result.getContactDetails().getEmail());
        assertEquals(PRIMARY_FIRSTNAME , result.getApplicants().getPrimary().getFirstName());
    }

    @Test
    public void adaptSamePrimaryTest() throws Exception {
        LifeQuoteWebRequest request = getLifeQuoteWebRequest();
        request.getLife().getPrimary().getInsurance().setPartner(YesNo.Y);

        final LifeQuoteRequest result = requestAdapter.adapt(request);
        assertEquals(EMAIL, result.getContactDetails().getEmail());
        assertEquals(PRIMARY_FIRSTNAME , result.getApplicants().getPrimary().getFirstName());
        assertEquals(PARTNER_SURNAME , result.getApplicants().getPartner().get().getLastName());
    }
}