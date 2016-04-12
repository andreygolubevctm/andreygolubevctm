package com.ctm.web.travel.quote.model;

import com.ctm.web.travel.model.form.TravelQuote;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.model.form.Travellers;
import com.ctm.web.travel.quote.model.request.TravelQuoteRequest;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


public class RequestAdapterTest {
    @Mock
    private TravelRequest travelRequest;

    private TravelQuote quote;

    @Mock
    private Travellers travellers;
    @Mock
    private com.ctm.web.travel.model.form.Filter filter;

    @Before
    public void setup() throws Exception {
        initMocks(this);
        quote = new TravelQuote();
        when(travelRequest.getQuote()).thenReturn(quote);
        quote.setTravellers(travellers);
        quote.setPolicyType("M");
        quote.setFilter(filter);
        quote.setAdults(2);
        quote.setChildren(1);
    }

    @Test
    public void testAdaptName() throws Exception {
        String firstName = "firstName";
        String lastName = "lastName";
        quote.setFirstName(firstName);
        quote.setSurname(lastName);
        TravelQuoteRequest quoteRequest = RequestAdapter.adapt(travelRequest);
        assertEquals(firstName, quoteRequest.getFirstName());
        assertEquals(lastName, quoteRequest.getLastName());
    }
}