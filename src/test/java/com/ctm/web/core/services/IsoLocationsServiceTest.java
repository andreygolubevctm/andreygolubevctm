package com.ctm.web.core.services;

import com.ctm.web.core.dao.IsoLocationsDao;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.mockito.MockitoAnnotations.initMocks;


public class IsoLocationsServiceTest {

    @Mock
    IsoLocationsDao dao;

    private IsoLocationsService service;


    @Before
    public void setUp() throws Exception {
        initMocks(this);
        service = new IsoLocationsService(dao);
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