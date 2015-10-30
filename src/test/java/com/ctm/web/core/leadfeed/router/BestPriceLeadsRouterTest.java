package com.ctm.web.core.leadfeed.router;

import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
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

import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;


@RunWith(PowerMockRunner.class)
@PrepareForTest( { BestPriceLeadsRouter.class, ApplicationService.class})
public class BestPriceLeadsRouterTest {

    private BestPriceLeadsRouter router;

    @Mock
    HttpServletRequest request;

    @Mock
    HttpServletResponse response;

    @Mock
    BestPriceLeadsDao dao;

    @Mock
    private java.io.PrintWriter writer;

    @Mock
    private LeadFeedService bestPriceLeadFeedService;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        PowerMockito.mockStatic(ApplicationService.class);

        List<Brand> brandsList = new ArrayList<>();
        Brand brand = new Brand();
        brandsList.add(brand);
        ArrayList<Vertical> verticals = new ArrayList<>();
        Vertical vertical = new Vertical();
        vertical.setType(Vertical.VerticalType.HEALTH);
        verticals.add(vertical);
        brand.setVerticals(verticals);
        PowerMockito.when(ApplicationService.getBrands()).thenReturn(brandsList);

        when(request.getRequestURI()).thenReturn("test/sergie/triggerBestPriceLeads.json");
        when(response.getWriter()).thenReturn(writer);

        when(bestPriceLeadFeedService.processBestPriceLeads(anyInt(), eq(Vertical.VerticalType.HEALTH.getCode()), anyInt(), anyObject())).thenReturn("successful");

        router = new BestPriceLeadsRouter(){

            @Override
            protected String getVerticalCode() {
                return Vertical.VerticalType.HEALTH.getCode();
            }

            @Override
            protected LeadFeedService getLeadFeedService() {
                return bestPriceLeadFeedService;
            }
        };

    }

    @Test
    public void doGetShouldProcessBestPriceLeads() throws Exception {
        router.doGet( request,  response);
        verify(response, times(0)).sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        verify(bestPriceLeadFeedService, times(1)).processBestPriceLeads(anyInt(), eq(Vertical.VerticalType.HEALTH.getCode()), anyInt(), anyObject());
    }
}