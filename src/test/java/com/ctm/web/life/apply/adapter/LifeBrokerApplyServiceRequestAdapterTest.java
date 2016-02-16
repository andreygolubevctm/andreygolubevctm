package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.core.web.DataParser;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.apply.model.request.LifeApplyWebRequest;
import com.ctm.web.life.form.model.LifeQuote;
import org.junit.Test;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertEquals;

public class LifeBrokerApplyServiceRequestAdapterTest {

    private static final String PARTNER_PRODUCT_ID = "c5e560a26d8fafbe313acc1988eb4e139430045e";
    private static final String EMAIL = "preload.testing@comparethemarket.com.au";
    private static final String PRIMARY_FIRSTNAME = "Joe";
    private static final String PARTNER_SURNAME = "Bloggs";

    @Test
    public void adaptTest() throws Exception {
        Data data = new Data();
        data.put("life/primary/insurance/partner" , "Y");
        data.put("life/primary/insurance/samecover" , "N");
        data.put("life/primary/insurance/term" , "500000");
        data.put("life/primary/insurance/termentry" , "500,000");
        data.put("life/primary/insurance/tpd" , "250000");
        data.put("life/primary/insurance/tpdentry" , "250,000");
        data.put("life/primary/insurance/trauma" , "150000");
        data.put("life/primary/insurance/traumaentry" , "150,000");
        data.put("life/primary/insurance/tpdanyown" , "A");
        data.put("life/partner/insurance/term" , "442343");
        data.put("life/partner/insurance/termentry" , "442,343");
        data.put("life/partner/insurance/tpd" , "423432");
        data.put("life/partner/insurance/tpdentry" , "423,432");
        data.put("life/partner/insurance/trauma" , "432432");
        data.put("life/partner/insurance/traumaentry" , "432,432");
        data.put("life/partner/insurance/tpdanyown" , "A");
        data.put("life/primary/insurance/frequency" , "M");
        data.put("life/primary/insurance/type" , "S");
        data.put("life/primary/firstName" , PRIMARY_FIRSTNAME);
        data.put("life/primary/lastname" , PARTNER_SURNAME);
        data.put("life/primary/gender" , "M");
        data.put("life/primary/dob" , "25/01/1967");
        data.put("life/primary/age" , "50");
        data.put("life/primary/smoker" , "N");
        data.put("life/primary/occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
        data.put("life/primary/hannover" , "1");
        data.put("life/primary/occupationTitle" , "Accountant - Qualified (professionally or degree)");
        data.put("life/partner/firstName" , "Josephine");
        data.put("life/partner/lastname" , "Bloggs");
        data.put("life/partner/gender" , "F");
        data.put("life/partner/dob" , "11/07/1971");
        data.put("life/partner/age" , "45");
        data.put("life/partner/smoker" , "N");
        data.put("life/partner/occupation" , "96740e86482091593a123e0f6d660e0d9d3054df");
        data.put("life/partner/hannover" , "2");
        data.put("life/partner/occupationTitle" , "Accounts Clerk (see Clerk)");
        data.put("life/contactDetails/email" , EMAIL);
        data.put("life/contactDetails/contactNumber" , "0400123123");
        data.put("life/contactDetails/contactNumberinput" , "(0400) 123 123");
        data.put("life/primary/state" , "QLD");
        data.put("life/primary/postCode" , "4007");
        data.put("life/privacyoptin" , "Y");
        data.put("life/contactDetails/call" , "Y");
        data.put("life/splitTestingJourney" , "0");
        data.put("life/refine/insurance/type" , "primary");

        LifeQuote lifeRequest = DataParser.createObjectFromData(data,LifeQuote.class, "life");

        LifeApplyWebRequest request = getLifeApplyWebRequest();
        request.setRequest_type("REQUEST-CALL");
        request.setClient_product_id("ff01712616fe6b7b97cd03ded3d2b492ba54a0f6");
        request.setCompany("AIA Australia");
        request.setPartner_product_id(PARTNER_PRODUCT_ID);
        request.setPartner_quote(YesNo.Y);
        request .setPartnerBrand("AIA Australia");

        LifeBrokerApplyServiceRequestAdapter requestAdapter = new LifeBrokerApplyServiceRequestAdapter(lifeRequest);
        final LifeBrokerApplyRequest result = requestAdapter.adapt(request);

        assertEquals(EMAIL, result.getContactDetails().getEmail());
        assertEquals(PRIMARY_FIRSTNAME , result.getApplicants().getPrimary().getFirstName());
        assertEquals(PARTNER_SURNAME , result.getApplicants().getPartner().get().getLastName());
        assertEquals(PARTNER_PRODUCT_ID,result.getPartnerProductId().get());
    }

    private LifeApplyWebRequest getLifeApplyWebRequest() {
        LifeApplyWebRequest request = new LifeApplyWebRequest();
        request.setTransactionId(2725461L);
        request .setVertical("life");
        return request;
    }

    @Test
    public void adaptNoPartnerTest() throws Exception {
        Data data = new Data();
        data.put("life/primary/insurance/partner" , "N");
                data.put("life/primary/insurance/term" , "500000");
                data.put("life/primary/insurance/termentry" , "500,000");
                data.put("life/primary/insurance/tpd" , "250000");
                data.put("life/primary/insurance/tpdentry" , "250,000");
                data.put("life/primary/insurance/trauma" , "150000");
                data.put("life/primary/insurance/traumaentry" , "150,000");
                data.put("life/primary/insurance/tpdanyown" , "A");
                data.put("life/primary/insurance/frequency" , "M");
                data.put("life/primary/insurance/type" , "S");
                data.put("life/primary/firstName" , PRIMARY_FIRSTNAME);
                data.put("life/primary/lastname" , PARTNER_SURNAME);
                data.put("life/primary/gender" , "M");
                data.put("life/primary/dob" , "25/01/1967");
                data.put("life/primary/age" , "50");
                data.put("life/primary/smoker" , "N");
                data.put("life/primary/occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
                data.put("life/primary/hannover" , "1");
                data.put("life/primary/occupationTitle" , "Accountant - Qualified (professionally or degree)");
                data.put("life/contactDetails/email" , EMAIL);
                data.put("life/contactDetails/contactNumber" , "0400123123");
                data.put("life/contactDetails/contactNumberinput" , "(0400) 123 123");
                data.put("life/primary/state" , "QLD");
                data.put("life/primary/postCode" , "4007");
                data.put("life/privacyoptin" , "Y");
                data.put("life/contactDetails/call" , "Y");
                data.put("life/splitTestingJourney" , "0");
                data.put("life/refine/insurance/type" , "primary");

        LifeQuote lifeRequest = DataParser.createObjectFromData(data,LifeQuote.class, "life");
        LifeBrokerApplyServiceRequestAdapter requestAdapter = new LifeBrokerApplyServiceRequestAdapter(lifeRequest);
        LifeApplyWebRequest request = getLifeApplyWebRequest();;
        request.setRequest_type("REQUEST-CALL");
        request.setClient_product_id("ff01712616fe6b7b97cd03ded3d2b492ba54a0f6");
        request.setCompany("OnePath");
        request.setPartner_quote(YesNo.N);
        request.setPartnerBrand("OnePath");

        final LifeBrokerApplyRequest result = requestAdapter.adapt(request);
        assertFalse(result.getPartnerProductId().isPresent());
        assertEquals(EMAIL, result.getContactDetails().getEmail());
        assertEquals(PRIMARY_FIRSTNAME , result.getApplicants().getPrimary().getFirstName());
    }

    @Test
    public void adaptSamePrimaryTest() throws Exception {
        Data data = new Data();
        data.put("life/primary/insurance/partner" , "Y");
        data.put("life/primary/insurance/samecover" , "Y");
        data.put("life/primary/insurance/term" , "500000");
        data.put("life/primary/insurance/termentry" , "500,000");
        data.put("life/primary/insurance/tpd" , "250000");
        data.put("life/primary/insurance/tpdentry" , "250,000");
        data.put("life/primary/insurance/trauma" , "150000");
        data.put("life/primary/insurance/traumaentry" , "150,000");
        data.put("life/primary/insurance/tpdanyown" , "A");
        data.put("life/partner/insurance/term" , "200000");
        data.put("life/partner/insurance/termentry" , "200,000");
        data.put("life/partner/insurance/tpd" , "125000");
        data.put("life/partner/insurance/tpdentry" , "125,000");
        data.put("life/partner/insurance/trauma" , "75000");
        data.put("life/partner/insurance/traumaentry" , "75,000");
        data.put("life/partner/insurance/tpdanyown" , "A");
        data.put("life/primary/insurance/frequency" , "M");
        data.put("life/primary/insurance/type" , "S");
        data.put("life/primary/firstName" , PRIMARY_FIRSTNAME);
        data.put("life/primary/lastname" , PARTNER_SURNAME);
        data.put("life/primary/gender" , "M");
        data.put("life/primary/dob" , "25/01/1967");
        data.put("life/primary/age" , "50");
        data.put("life/primary/smoker" , "N");
        data.put("life/primary/occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
        data.put("life/primary/hannover" , "1");
        data.put("life/primary/occupationTitle" , "Accountant - Qualified (professionally or degree)");
        data.put("life/partner/firstName" , "Josephine");
        data.put("life/partner/lastname" , "Bloggs");
        data.put("life/partner/gender" , "F");
        data.put("life/partner/dob" , "11/07/1971");
        data.put("life/partner/age" , "45");
        data.put("life/partner/smoker" , "N");
        data.put("life/partner/occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
        data.put("life/partner/hannover" , "1");
        data.put("life/partner/occupationTitle" , "Accountant - Qualified (professionally or degree)");
        data.put("life/contactDetails/email" , EMAIL);
        data.put("life/contactDetails/contactNumber" , "0400123123");
        data.put("life/contactDetails/contactNumberinput" , "(0400) 123 123");
        data.put("life/primary/state" , "QLD");
        data.put("life/primary/postCode" , "4007");
        data.put("life/privacyoptin" , "Y");
        data.put("life/contactDetails/call" , "Y");
        data.put("life/splitTestingJourney" , "0");
        data.put("life/refine/insurance/type" , "primary");

        LifeQuote lifeRequest = DataParser.createObjectFromData(data,LifeQuote.class, "life");
        LifeBrokerApplyServiceRequestAdapter requestAdapter = new LifeBrokerApplyServiceRequestAdapter(lifeRequest);
        LifeApplyWebRequest request = getLifeApplyWebRequest();
        request.setRequest_type("REQUEST-CALL");
        request.setClient_product_id("ff01712616fe6b7b97cd03ded3d2b492ba54a0f6");
        request.setCompany("AIA Australia");
        request.setPartner_product_id(PARTNER_PRODUCT_ID);
        request.setPartner_quote(YesNo.Y);
        request.setPartnerBrand("AIA Australia");;

        final LifeBrokerApplyRequest result = requestAdapter.adapt(request);
        assertEquals(PARTNER_PRODUCT_ID,result.getPartnerProductId().get());
        assertEquals(EMAIL, result.getContactDetails().getEmail());
        assertEquals(PRIMARY_FIRSTNAME , result.getApplicants().getPrimary().getFirstName());
        assertEquals(PARTNER_SURNAME , result.getApplicants().getPartner().get().getLastName());
    }
}