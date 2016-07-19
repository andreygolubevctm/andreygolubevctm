package com.ctm.web.life.adapter;

import com.ctm.web.core.web.DataParser;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.form.model.LifeQuote;
import org.junit.Before;
import org.junit.Test;


public class LifeServiceRequestAdapterTest {

    private static final String EMAIL = "preload.testing@comparethemarket.com.au";
    private static final String PRIMARY_FIRSTNAME = "Joe";
    private static final String PARTNER_SURNAME = "Bloggs";


    private LifeQuote lifeQuoteRequest;

    @Before

    public void setup(){
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

        lifeQuoteRequest = DataParser.createObjectFromData(data,LifeQuote.class, "life");
    }

    @Test
    public void adaptTest() throws Exception {

        LifeServiceRequestAdapter.getApplicants(lifeQuoteRequest.getPrimary(),
                lifeQuoteRequest.getPartner());
    }

    @Test
    public void adaptNoPartnerTest() throws Exception {
        LifeServiceRequestAdapter.createContactDetails(
                lifeQuoteRequest.getContactDetails(),
                lifeQuoteRequest.getPrimary());
    }
}