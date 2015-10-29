package com.ctm.web.core.services;

import org.junit.Before;
import org.junit.Test;

/**
 * Created by lbuchanan on 29/10/2015.
 */
public class IsoLocationsServiceTest {

    private IsoLocationsService service;


    @Before
    public void setUp() throws Exception {
        service = new IsoLocationsService();
    }

    @Test
    public void testFetchCountryList() throws Exception {
        service.fetchCountryList();

    }

    @Test
    public void testFetchSearchResults() throws Exception {
        String searchTerm = "test";
        service.fetchSearchResults( searchTerm);

    }
}