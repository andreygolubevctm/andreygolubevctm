package com.ctm.web.core.web.core.leadfeed.router;

import com.ctm.web.core.leadfeed.router.LeadFeedRouter;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static org.mockito.MockitoAnnotations.initMocks;

/**
 * Created by lbuchanan on 29/10/2015.
 */
public class LeadFeedRouterTest {

    private LeadFeedRouter leadFeedRouter;

    @Mock
    private HttpServletRequest request;
    @Mock
    private HttpServletResponse response;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        leadFeedRouter = new LeadFeedRouter(){

            @Override
            protected String getVerticalCode() {
                return null;
            }

            @Override
            protected LeadFeedService getLeadFeedService() {
                return null;
            }
        };
    }

    @Test
    public void testDoPost() throws Exception {
        leadFeedRouter.doPost( request,  response);

    }
}