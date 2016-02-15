package com.ctm.web.core.leadfeed.utils;

import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import java.util.Date;

import static org.mockito.MockitoAnnotations.initMocks;


public class LeadFeedTest {

    @Mock
    private ContentService contentService;
    @Mock
    private LeadFeedTouchService leadFeedTouchService;
    @Mock
    private Brand brand;

    private LeadFeed leadFeed;

    private String phoneNumber = "0411111111";
    private int brandId = 1;
    private int verticalId = 1;
    private Date eventDate = new Date();
    private Vertical.VerticalType verticalType = Vertical.VerticalType.LIFE;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        leadFeed = new LeadFeed( contentService,  leadFeedTouchService);

    }

    @Test
    public void testIsTestOnlyLead() throws Exception {
        LeadFeedData leadData = new LeadFeedData();
        leadFeed.isTestOnlyLead(leadData);
    }

    @Test
    public void testIsTestOnlyLead1() throws Exception {
        leadFeed.isTestOnlyLead( phoneNumber,
         brandId,
         verticalId,
         eventDate);

    }

    @Test
    public void testIsTestOnlyLead2() throws Exception {
        leadFeed.isTestOnlyLead( phoneNumber,  brand,  verticalType,  eventDate);

    }
}