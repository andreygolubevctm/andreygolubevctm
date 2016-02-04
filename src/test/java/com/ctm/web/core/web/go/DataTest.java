package com.ctm.web.core.web.go;

import com.ctm.web.life.model.request.Insurance;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class DataTest {



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

        Insurance.Builder insuranceB = new Insurance.Builder();

        Insurance request = data.createObjectFromData(insuranceB.build(), "life/primary/insurance");
        assertEquals("M" , request.getFrequency());
    }

}