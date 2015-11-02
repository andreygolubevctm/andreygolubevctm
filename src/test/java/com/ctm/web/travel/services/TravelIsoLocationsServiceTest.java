package com.ctm.web.travel.services;

import com.ctm.web.core.dao.IsoLocationsDao;
import com.ctm.web.core.model.IsoLocations;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyList;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


public class TravelIsoLocationsServiceTest {

    @Mock
    private IsoLocationsDao dao;

    private TravelIsoLocationsService service;
    private java.util.ArrayList<com.ctm.web.core.model.IsoLocations> countries;
    private java.util.ArrayList<com.ctm.web.core.model.IsoLocations> countriesNotTopTen;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        countries = new ArrayList<>();
        IsoLocations location = new IsoLocations();
        location.setCountryName("Russia");
        location.setIsoCode("RUS");
        countries.add(location);

        countriesNotTopTen = new ArrayList<>();
        location = new IsoLocations();
        countriesNotTopTen.add(location);

        service = new TravelIsoLocationsService(dao);
        when(dao.getCountriesByIsoCodes((List<String>) anyList())).thenReturn(countries);
        when(dao.getIsoLocations(null)).thenReturn(countriesNotTopTen);
    }

    @Test
    public void testAddTopTenTravelDestinations() throws Exception {
        JSONObject json = new JSONObject();
        JSONObject topTen = service.addTopTenTravelDestinations(json);
        JSONObject topTenFirstLocation = (JSONObject) topTen.getJSONArray("topTen").get(0);
        assertEquals("Russia", topTenFirstLocation.getString("countryName"));

    }

    @Test
    public void testGetCountrySelectionList() throws Exception {
        JSONObject countyList = service.getCountrySelectionList();
        JSONObject topTenFirstLocation = (JSONObject) countyList.getJSONArray("topTen").get(0);
        assertEquals("Russia", topTenFirstLocation.getString("countryName"));
    }
}