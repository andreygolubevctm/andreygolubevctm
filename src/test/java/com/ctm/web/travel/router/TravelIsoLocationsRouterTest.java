package com.ctm.web.travel.router;

import com.ctm.web.core.services.IsoLocationsService;
import com.ctm.web.travel.services.TravelIsoLocationsService;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;


public class TravelIsoLocationsRouterTest {

    private TravelIsoLocationsRouter router;
    private org.json.JSONObject countryList;

    @Mock
    private HttpServletRequest request;

    @Mock
    private TravelIsoLocationsService isoLocationsService;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        router = new TravelIsoLocationsRouter(isoLocationsService);
        countryList = new JSONObject();
        when(isoLocationsService.fetchCountryList()).thenReturn(countryList);
    }

    @Test
    public void testGetService() throws Exception {
        IsoLocationsService serviceReturned = router.getService();
        assertEquals(isoLocationsService, serviceReturned);
    }

    @Test
    public void testFetchCountryListShowTopTen() throws Exception {
        when(request.getParameter("showTopTen")).thenReturn("true");
        router.fetchCountryList(request);
        verify(isoLocationsService,times(1)).addTopTenTravelDestinations(countryList);
    }

    @Test
    public void testFetchCountryListDontShowTopTen() throws Exception {
        when(request.getParameter("showTopTen")).thenReturn("false");
        router.fetchCountryList(request);
        verify(isoLocationsService,times(0)).addTopTenTravelDestinations(countryList);
    }
}