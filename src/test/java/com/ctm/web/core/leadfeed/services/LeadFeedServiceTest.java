package com.ctm.web.core.leadfeed.services;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.Touch;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class LeadFeedServiceTest {
    private LeadFeedService leadFeedService;

    @Mock
    private HttpServletRequest request;
    @Mock
    private HttpServletResponse response;
    @Mock
    private BestPriceLeadsDao bestPriceDao;
    @Mock
    ContentService contentService;
    @Mock
    Content ignore;
    @Mock
    private IProviderLeadFeedService providerLeadFeedService;
    @Mock
    private LeadFeedTouchService leadFeedTouchService;

    private Date date = new Date();
    private int brandId = 1;
    private int verticalId = 1;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        leadFeedService = new LeadFeedService(bestPriceDao,contentService, leadFeedTouchService) {
            @Override
            protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, Touch.TouchType touchType) {
                return LeadResponseStatus.SUCCESS;
            }
        };
        when(ignore.getSupplementaryValueByKey("phone")).thenReturn("0412345678");
        when(contentService.getContent("ignoreMatchingFormField", brandId, verticalId, date, true)).thenReturn(ignore);
    }

    @Test
    public void testCallMeBack() throws Exception {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setPhoneNumber("041111111111111");
        leadData.setTransactionId(1000L);
        leadData.setBrandCode("test");
        leadData.setBrandId(brandId);
        leadData.setVerticalId(verticalId);
        leadData.setEventDate(date);

        LeadFeedService.LeadResponseStatus outcome = leadFeedService.callMeBack(leadData);
        assertEquals(LeadFeedService.LeadResponseStatus.SUCCESS, outcome);
    }


    @Test
    public void testGetLeadResponseStatus() throws Exception {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setPhoneNumber("041111111111111");
        leadData.setTransactionId(1000L);
        leadData.setBrandCode("test");
        leadData.setBrandId(brandId);
        leadData.setVerticalId(verticalId);
        leadData.setEventDate(date);

        LeadFeedService.LeadType leadType = LeadFeedService.LeadType.BEST_PRICE;

        when(providerLeadFeedService.process(leadType, leadData)).thenReturn(LeadFeedService.LeadResponseStatus.SUCCESS);

        LeadFeedService.LeadResponseStatus outcome = leadFeedService.getLeadResponseStatus( leadType,  leadData,
                Touch.TouchType.APPLY,  providerLeadFeedService);
        assertEquals(LeadFeedService.LeadResponseStatus.SUCCESS, outcome);
    }
}
