package com.ctm.web.life.apply.model.request;

import com.ctm.web.core.model.formData.YesNo;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class LifeApplyWebRequestTest {

    LifeApplyWebRequest request;

    @Before
    public void setUp() throws Exception {
         request = new LifeApplyWebRequest();
    }

    @Test
    public void testGetRequest_type() throws Exception {
        String request_type = "request_type";
        request.setRequest_type(request_type);
        assertEquals(request_type , request.getRequest_type());

    }

    @Test
    public void testGetApi_ref() throws Exception {
        String api_ref = "Api_ref";
        request.setRequest_type(api_ref);
        assertEquals(api_ref , request.getRequest_type());
    }

    @Test
    public void testGetPartner_quote() throws Exception {
        YesNo partner_quote = YesNo.Y;
        request.setPartner_quote(partner_quote);
        assertEquals(partner_quote , request.getPartner_quote());
    }

    @Test
    public void testGetPartnerBrand() throws Exception {
        String partnerBrand = "PartnerBrand";
        request.setPartnerBrand(partnerBrand);
        assertEquals(partnerBrand , request.getPartnerBrand());
    }
}