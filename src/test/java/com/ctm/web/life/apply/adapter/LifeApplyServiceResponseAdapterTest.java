package com.ctm.web.life.apply.adapter;

import com.ctm.interfaces.common.types.Status;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.life.apply.response.LifeApplyWebResponseResults;
import org.junit.Before;
import org.junit.Test;

import static junit.framework.TestCase.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;


public class LifeApplyServiceResponseAdapterTest {

    private LifeApplyServiceResponseAdapter adapter;

    @Before
    public void setUp() throws Exception {
        adapter = new LifeApplyServiceResponseAdapter();
    }

    @Test
    public void testAdaptNoPartner() throws Exception {
        LifeApplyResponse applyResponse = new LifeApplyResponse.Builder<>()
                .responseStatus(Status.REGISTERED)
                .additionalInformation(LifeApplyResponse.PRIMARY_LIFEBROKER_INFO_URL, "test")
                .additionalInformation(LifeApplyResponse.PRIMARY_LIFEBROKER_PDS , "test")
                .build();
        LifeApplyWebResponseResults.Builder result = adapter.adapt(applyResponse);
        assertTrue(result.build().isSuccess());
        assertNotNull(result.build().getSelection());
    }

    @Test
    public void testAdaptWithPartner() throws Exception {
        LifeApplyResponse applyResponse = new LifeApplyResponse.Builder<>()
                .responseStatus(Status.REGISTERED)
                .additionalInformation(LifeApplyResponse.PRIMARY_LIFEBROKER_INFO_URL, "test-info-url")
                .additionalInformation(LifeApplyResponse.PRIMARY_LIFEBROKER_PDS , "test.pdf")
                .additionalInformation(LifeApplyResponse.PARTNER_LIFEBROKER_INFO_URL , "test-partner")
                .additionalInformation(LifeApplyResponse.PARTNER_LIFEBROKER_PDS , "test-partner")
                .build();
        LifeApplyWebResponseResults.Builder result = adapter.adapt(applyResponse);
        assertTrue(result.build().isSuccess());
        assertNotNull(result.build().getSelection());
    }

    @Test
    public void testAdaptWithPartnerNoAdditionalInformation() throws Exception {
        LifeApplyResponse applyResponse = new LifeApplyResponse.Builder<>()
                .responseStatus(Status.REGISTERED)
                .build();
        LifeApplyWebResponseResults.Builder result = adapter.adapt(applyResponse);
        assertTrue(result.build().isSuccess());
        assertNull(result.build().getSelection());
    }
}