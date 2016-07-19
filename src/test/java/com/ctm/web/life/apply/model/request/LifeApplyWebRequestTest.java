package com.ctm.web.life.apply.model.request;

import com.ctm.web.core.model.formData.YesNo;
import org.junit.Before;
import org.junit.Test;

import static com.ctm.web.life.apply.adapter.LifeBrokerApplyServiceRequestAdapterTestUtils.setPartnerQuote;
import static com.ctm.web.life.apply.adapter.LifeBrokerApplyServiceRequestAdapterTestUtils.setRequestType;
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
        setRequestType( request,  request_type);
        assertEquals(request_type , request.getRequestType());

    }

    @Test
    public void testGetApi_ref() throws Exception {
        String api_ref = "Api_ref";
        setRequestType( request,  api_ref);
        assertEquals(api_ref , request.getRequestType());
    }

    @Test
    public void testGetPartner_quote() throws Exception {
        YesNo partner_quote = YesNo.Y;
        setPartnerQuote( request, partner_quote);
        assertEquals(partner_quote , request.getPartner().getQuote());
    }

    @Test
    public void testGetPartnerBrand() throws Exception {
        String partnerBrand = "PartnerBrand";
        request.setPartnerBrand(partnerBrand);
        assertEquals(partnerBrand , request.getPartnerBrand());
    }
}