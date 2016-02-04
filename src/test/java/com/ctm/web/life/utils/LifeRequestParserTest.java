package com.ctm.web.life.utils;

import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.model.request.LifeRequest;
import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class LifeRequestParserTest {

    @Test
    public void testParseRequest() throws Exception {
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
        data.put("life/primary/firstName" , "Joe");
        data.put("life/primary/lastname" , "Blogs");
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
        data.put("life/contactDetails/email" , "preload.testing@comparethemarket.com.au");
        data.put("life/contactDetails/contactNumber" , "0400123123");
        data.put("life/contactDetails/contactNumberinput" , "(0400) 123 123");
        data.put("life/primary/state" , "QLD");
        data.put("life/primary/postCode" , "4007");
        data.put("life/privacyoptin" , "Y");
        data.put("life/contactDetails/call" , "Y");
        data.put("life/splitTestingJourney" , "0");
        data.put("life/refine/insurance/type" , "primary");

        LifeRequest request = LifeRequestParser.parseRequest(data, "life");
        assertEquals("M" , request.getPrimary().getInsurance().getFrequency());
        assertEquals("0400123123" , request.getContactDetails().getContactNumber());
    }


}