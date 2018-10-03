package com.ctm.web.core.leadfeed.services;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.Touch;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class LeadFeedServiceTest {
    private TestLeadFeedService leadFeedService;

    @Mock
    private  LeadFeedTouchService leadFeedTouchService;
    @Mock
    private IProviderLeadFeedService providerLeadFeedService;

    private class TestLeadFeedService extends LeadFeedService{

        private boolean processCalled = false;

        public TestLeadFeedService(BestPriceLeadsDao bestPriceDao, ContentService contentService,
                                   LeadFeedTouchService leadFeedTouchService) {
            super(bestPriceDao, contentService,leadFeedTouchService);
        }

        @Override
        protected com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus process(com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType
        leadType, LeadFeedData leadData, Touch.TouchType touchType) {
            processCalled = true;
            return com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.SUCCESS;
        }

        /**
         * isTestOnlyLead() will check whether the email or phone number in the lead data has been
         * flagged as test data.
         *
         * @param leadData
         * @return
         * @throws LeadFeedException
         */
        public Boolean isTestOnlyLead(LeadFeedData leadData) throws LeadFeedException {
            return super.isTestOnlyLead( leadData);
        }

        public boolean isProcessCalled() {
            return processCalled;
        }
    };

    @Mock
    private HttpServletRequest request;
    @Mock
    private HttpServletResponse response;
    @Mock
    private BestPriceLeadsDao bestPriceDao;
    @Mock
    ContentService contentService;
    @Mock
    Content ignoreMatchingFormFieldContent;

    private Date date = new Date();
    private int brandId = 1;
    private int verticalId = 1;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        leadFeedService = new TestLeadFeedService(bestPriceDao,contentService, leadFeedTouchService);
        when(ignoreMatchingFormFieldContent.getSupplementaryValueByKey("phone")).thenReturn("0412345678");
        when(contentService.getContent("ignoreMatchingFormField", brandId, verticalId, date, true)).thenReturn(ignoreMatchingFormFieldContent);
    }


    @Test
    public void testIsTestOnlyLeadEmptyNumber() throws Exception {
        String testPhoneNumber = "";
        LeadFeedData leadData = getLeadFeedData(testPhoneNumber);
        Boolean outcome = leadFeedService.isTestOnlyLead(leadData);
        assertEquals(false, outcome);

    }

    @Test
    public void testIsTestOnlyLeadTestNumber() throws Exception {
        String testPhoneNumber = "0412345678";
        LeadFeedData leadData = getLeadFeedData(testPhoneNumber);
        when(ignoreMatchingFormFieldContent.getSupplementaryValueByKey("phone")).thenReturn(testPhoneNumber);
        Boolean outcome = leadFeedService.isTestOnlyLead(leadData);
        assertEquals(true, outcome);
    }

    private LeadFeedData getLeadFeedData(String testPhoneNumber) {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setPhoneNumber(testPhoneNumber);
        leadData.setTransactionId(1000L);
        leadData.setBrandCode("test");
        leadData.setBrandId(brandId);
        leadData.setVerticalId(verticalId);
        leadData.setEventDate(date);
        return leadData;
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
