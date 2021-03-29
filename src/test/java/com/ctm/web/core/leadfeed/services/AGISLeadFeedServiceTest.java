package com.ctm.web.core.leadfeed.services;

import com.ctm.aglead.ws.Request;
import com.ctm.aglead.ws.Response;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.settings.PageSettings;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.IOException;

import static org.mockito.Mockito.when;

public class AGISLeadFeedServiceTest {


    @Mock
    private PageSettings pageSettings;

    @Mock
    private Request request;

    @Mock
    private Response response;

    public static final class DummyAGISLeadFeedService extends AGISLeadFeedService {

        @Override
        protected AGISLeadFeedRequest getModel(LeadFeedService.LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
            return null;
        }
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }

    @Test(expected = IOException.class)
    public void testRequestForException() throws IOException {
        DummyAGISLeadFeedService leadFeedService = new DummyAGISLeadFeedService();
        when(pageSettings.getVerticalCode()).thenReturn("test-vertical-code");

        Response response = leadFeedService.request(pageSettings, request, "http://dontgoanwhere.com", 0l);

    }

}
