package com.ctm.web.core.leadfeed.utils;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import java.util.Date;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


public class LeadFeedTest {

    @Mock
    private ContentService contentService;
    @Mock
    private LeadFeedTouchService leadFeedTouchService;
    @Mock
    private Brand brand;
    @Mock
    private Content content;
    @Mock
    private com.ctm.web.core.model.settings.Vertical vertical;

    private LeadFeed leadFeed;
    private String phoneNumber = "0411111112";
    private String testPhoneNumber = "0411111111";
    private int brandId = 1;
    private int verticalId = 1;
    private Date eventDate = new Date();
    private Vertical.VerticalType verticalType = Vertical.VerticalType.HEALTH;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        leadFeed = new LeadFeed( contentService,  leadFeedTouchService);
        when(contentService.getContent("ignoreMatchingFormField",brandId, verticalId, eventDate, true)).thenReturn(content);
        when(brand.getVerticalByCode(anyString())).thenReturn(vertical);
        when(brand.getId()).thenReturn(brandId);
        when(vertical.getId()).thenReturn(verticalId);
        when(content.getSupplementaryValueByKey("phone")).thenReturn(testPhoneNumber);

    }

    @Test
    public void testIsTestOnlyLead() throws Exception {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setBrandId(brandId);
        leadData.setVerticalId(verticalId);
        leadData.setEventDate(eventDate);
        leadData.setPhoneNumber(phoneNumber);
        boolean testLead = leadFeed.isTestOnlyLead(leadData);
        assertFalse(testLead);

        leadData.setPhoneNumber(testPhoneNumber);
        testLead = leadFeed.isTestOnlyLead(leadData);
        assertTrue(testLead);
    }

    @Test
    public void testIsTestOnlyLead1() throws Exception {
        boolean testLead =  leadFeed.isTestOnlyLead( phoneNumber,
         brandId,
         verticalId,
         eventDate);
        assertFalse(testLead);

         testLead =  leadFeed.isTestOnlyLead( testPhoneNumber,
                brandId,
                verticalId,
                eventDate);
        assertTrue(testLead);
    }

    @Test
    public void testIsTestOnlyLead2() throws Exception {
        boolean result =  leadFeed.isTestOnlyLead( phoneNumber,  brand,  verticalType,  eventDate);
        assertFalse(result);

         result =  leadFeed.isTestOnlyLead( testPhoneNumber,  brand,  verticalType,  eventDate);
        assertTrue(result);

    }
}