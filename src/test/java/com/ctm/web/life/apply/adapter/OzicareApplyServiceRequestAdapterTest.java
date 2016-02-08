package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.request.ozicare.OzicareApplyRequest;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.core.web.DataParser;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.form.model.LifeQuote;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class OzicareApplyServiceRequestAdapterTest {

    private static final String PARTNER_PRODUCT_ID = "OZIC_LIFE_1";
    private static final String PRODUCT_ID = "OZIC_LIFE_1";
    private static final String EMAIL = "preload.testing@comparethemarket.com.au";
    private static final String PRIMARY_FIRSTNAME = "Joe";
    private static final String SURNAME = "Bloggs";
    public static final String API_REF = "c4aa7ccb59f5a461039f10";
    public static final String REQUEST_TYPE = "REQUEST-CALL";
    public static final String VERTICAL = "life";
    public static final long TRANSACTION_ID = 2214716L;
    public static final String LEAD_NUMBER = "Z6B000345";
    public static final String COMPANY = "ozicare";
    public static final String PARTNER_BRAND = "OZIC";
    private LifeApplyPostRequestPayload request;

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
        data.put("life/primary/lastname" , SURNAME);
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

        request = new LifeApplyPostRequestPayload.Builder()
                .request_type(REQUEST_TYPE)
                .api_ref(API_REF)
                .client_product_id(PRODUCT_ID)
                .company(COMPANY)
                .client_product_id(PARTNER_PRODUCT_ID)
                .partner_product_id(PARTNER_PRODUCT_ID)
                .partner_quote(YesNo.Y)
                .partnerBrand(PARTNER_BRAND)
                .transactionId(TRANSACTION_ID)
                .lead_number(LEAD_NUMBER)
                .vertical(VERTICAL)
                .build();

        OzicareApplyServiceRequestAdapter requestAdapter = new OzicareApplyServiceRequestAdapter(lifeRequest);
        final OzicareApplyRequest result = requestAdapter.adapt(request);

        assertEquals(PRIMARY_FIRSTNAME , result.getFirstName());
        assertEquals(PRODUCT_ID,result.getProductId());
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
        data.put("life/primary/lastname" , SURNAME);
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
        OzicareApplyServiceRequestAdapter requestAdapter = new OzicareApplyServiceRequestAdapter(lifeRequest);
        request = new LifeApplyPostRequestPayload.Builder()
                .request_type("REQUEST-CALL")
                .api_ref("c4aa7ccb59f5a461039f10")
                .client_product_id(PRODUCT_ID)
                .company("OnePath")
                .partner_quote(YesNo.N)
                .partnerBrand("OnePath")
                .transactionId(2725461L)
                .vertical("life")
                .build();

        final OzicareApplyRequest result = requestAdapter.adapt(request);
        assertEquals(PRODUCT_ID,result.getProductId());
        assertEquals(PRIMARY_FIRSTNAME , result.getFirstName());
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
        data.put("life/primary/lastname" , SURNAME);
        data.put("life/primary/gender" , "M");
        data.put("life/primary/dob" , "25/01/1967");
        data.put("life/primary/age" , "50");
        data.put("life/primary/smoker" , "N");
        data.put("life/primary/occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
        data.put("life/primary/hannover" , "1");
        data.put("life/primary/occupationTitle" , "Accountant - Qualified (professionally or degree)");
        data.put("life/partner/firstName" , "Josephine");
        data.put("life/partner/lastname" , SURNAME);
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
        OzicareApplyServiceRequestAdapter requestAdapter = new OzicareApplyServiceRequestAdapter(lifeRequest);
        request = new LifeApplyPostRequestPayload.Builder()
                .request_type("REQUEST-CALL")
                .api_ref("c4aa7ccb59f5a461039f10")
                .client_product_id(PRODUCT_ID)
                .company("AIA Australia")
                .partner_product_id(PARTNER_PRODUCT_ID)
                .partner_quote(YesNo.Y)
                .partnerBrand("AIA Australia")
                .transactionId(2725461L)
                .vertical("life")
                .build();

        final OzicareApplyRequest result = requestAdapter.adapt(request);
        assertEquals(PRODUCT_ID,result.getProductId());
        assertEquals(PRIMARY_FIRSTNAME , result.getFirstName());
    }

}