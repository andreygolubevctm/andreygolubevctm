package com.ctm.web.core.leadfeed.router;

import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;

@RunWith(PowerMockRunner.class)
@PrepareForTest( { LeadFeedRouter.class, SettingsService.class, ApplicationService.class})
public class LeadFeedRouterTest {

    private LeadFeedRouter router;

    @Mock
    HttpServletRequest request;

    @Mock
    HttpServletResponse response;

    @Mock
    BestPriceLeadsDao dao;

    @Mock
    private java.io.PrintWriter writer;

    @Mock
    private LeadFeedService leadFeedService;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        PowerMockito.mockStatic(SettingsService.class);
        PowerMockito.mockStatic(ApplicationService.class);

        List<Brand> brandsList = new ArrayList<>();
        Brand brand = new Brand();
        brandsList.add(brand);
        ArrayList<Vertical> verticals = new ArrayList<>();
        Vertical vertical = new Vertical();
        vertical.setType(Vertical.VerticalType.HEALTH);
        verticals.add(vertical);
        brand.setVerticals(verticals);

        when(request.getRequestURI()).thenReturn("test/sergie/getacall.json");
        when(response.getWriter()).thenReturn(writer);

        LeadFeedService.LeadResponseStatus success = LeadFeedService.LeadResponseStatus.SUCCESS;
        when(leadFeedService.callDirect(anyObject())).thenReturn(success);

        PowerMockito.when(ApplicationService.getBrandByCode(anyString())).thenReturn(brand);

        router = new LeadFeedRouter(){

            @Override
            protected String getVerticalCode() {
                return Vertical.VerticalType.HEALTH.getCode();
            }

            @Override
            protected LeadFeedService getLeadFeedService() {
                return leadFeedService;
            }
        };

    }

    @Test
    public void doGetShouldCallDirect() throws Exception {
        when(request.getParameter("phonecallme")).thenReturn(LeadFeedData.CallType.CALL_DIRECT.getCallType());
        router.doPost( request,  response);
        verify(response, times(0)).sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        verify(leadFeedService, times(1)).callDirect(anyObject());
    }

}