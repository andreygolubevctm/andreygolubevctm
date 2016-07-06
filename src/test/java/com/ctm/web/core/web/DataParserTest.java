package com.ctm.web.core.web;

import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.form.model.Insurance;
import com.ctm.web.life.form.model.LifeQuote;
import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class DataParserTest {

    @Test
    public void shouldCreateObjectFromData(){

        Data data = new Data();
        data.put("life/primary/insurance/partner" , "Y");
        data.put("life/primary/insurance/samecover" , "Y");
        data.put("life/primary/insurance/term" , "500000");
        data.put("life/primary/insurance/termentry" , "500,000");
        data.put("life/primary/insurance/tpd" , "250000");
        data.put("life/primary/insurance/tpdentry" , "250,000");
        data.put("life_primary_insurance/trauma" , "150000");
        data.put("life_primary_insurance/traumaentry" , "150,000");
        data.put("life/primary/insurance/tpdanyown" , "A");
        data.put("life_partner/insurance/term" , "200000");
        data.put("life_partner/insurance/termentry" , "200,000");
        data.put("life_partner/insurance/tpd" , "125000");
        data.put("life_partner/insurance/tpdentry" , "125,000");
        data.put("life_partner/insurance/trauma" , "75000");
        data.put("life_partner/insurance/traumaentry" , "75,000");
        data.put("life_partner/insurance/tpdanyown" , "A");
        data.put("life/primary/insurance/frequency" , "M");
        data.put("life_primary/insurance/type" , "S");
        data.put("life/primary_firstName" , "Joe");
        data.put("life/primary_lastname" , "Blogs");
        data.put("life_primary_gender" , "M");
        data.put("life_primary_dob" , "25/01/1967");
        data.put("life_primary_age" , "50");
        data.put("life_primary_smoker" , "N");
        data.put("life_primary_occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
        data.put("life_primary_hannover" , "1");
        data.put("life_primary_occupationTitle" , "Accountant - Qualified (professionally or degree)");
        data.put("life_partner_firstName" , "Josephine");
        data.put("life_partner_lastname" , "Bloggs");
        data.put("life_partner_gender" , "F");
        data.put("life_partner_dob" , "11/07/1971");
        data.put("life_partner_age" , "45");
        data.put("life_partner_smoker" , "N");
        data.put("life_partner_occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
        data.put("life_partner_hannover" , "1");
        data.put("life_partner_occupationTitle" , "Accountant - Qualified (professionally or degree)");
        data.put("life_contactDetails_email" , "preload.testing@comparethemarket.com.au");
        data.put("life_contactDetails_contactNumber" , "0400123123");
        data.put("life_contactDetails_contactNumberinput" , "(0400) 123 123");
        data.put("life_primary_state" , "QLD");
        data.put("life_primary_postCode" , "4007");
        data.put("life_privacyoptin" , "Y");
        data.put("life_contactDetails_call" , "Y");
        data.put("life_splitTestingJourney" , "0");
        data.put("life/refine/insurance/type" , "primary");

        Insurance request = DataParser.createObjectFromData(data, Insurance.class, "life/primary/insurance");
        assertEquals("M" , request.getFrequency());
    }

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

        LifeQuote request = DataParser.createObjectFromData(data,LifeQuote.class, "life");
        assertEquals("M" , request.getPrimary().getInsurance().getFrequency());
        assertEquals("Josephine" , request.getPartner().getFirstName() );
        assertEquals(YesNo.Y , request.getPrimary().getInsurance().getSamecover());
        assertEquals("0400123123" , request.getContactDetails().getContactNumber());
    }

}