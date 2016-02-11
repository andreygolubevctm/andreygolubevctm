package com.ctm.web.core.leadfeed.services;

import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.services.AccessTouchService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.mockito.MockitoAnnotations.initMocks;

public class LeadFeedTouchServiceTest {

    private LeadFeedTouchService leadFeedTouchService;

    @Mock
    private AccessTouchService touchService;

    private Touch.TouchType touchType = Touch.TouchType.APPLY;
    private LeadFeedData leadData;
    private Long transactionId = 10000L;
    private String productId = "productId";

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        leadFeedTouchService = new LeadFeedTouchService( touchService);
        leadData = new LeadFeedData();
        leadData.setTransactionId(transactionId);
        leadData.setProductId(productId);
    }

    @Test
    public void testRecordTouchWithLeadData() throws Exception {
        leadFeedTouchService.recordTouch(touchType,  leadData);
    }

    @Test
    public void testRecordTouch() throws Exception {
        leadFeedTouchService.recordTouch(touchType,  productId,  transactionId);

    }
}