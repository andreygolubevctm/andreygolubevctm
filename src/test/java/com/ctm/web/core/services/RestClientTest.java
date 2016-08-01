package com.ctm.web.core.services;

import com.ctm.web.core.model.QuoteServiceProperties;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import java.util.LinkedHashMap;
import java.util.Map;

import static java.util.Collections.emptyMap;
import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class RestClientTest {

    @Mock
    private ObjectMapper objectMapper;

    @Mock
    private QuoteServiceProperties quoteServiceProperties;

    private RestClient restClient;

    @Before
    public void setUp() {
        initMocks(this);
        restClient = new RestClient(objectMapper);
    }

    @Test
    public void testCreateGETUrlWithoutParams() {
        when(quoteServiceProperties.getServiceUrl()).thenReturn("http://localhost:8080");
        final String url = restClient.createGETUrl(quoteServiceProperties, Endpoint.instanceOf("test"), emptyMap());
        assertEquals("http://localhost:8080/test", url);

    }

    @Test
    public void testCreateGETUrlWithParams() {
        when(quoteServiceProperties.getServiceUrl()).thenReturn("http://localhost:8080");
        Map<String, String> params = new LinkedHashMap<>();
        params.put("param1", "1");
        params.put("param2", "2");
        final String url = restClient.createGETUrl(quoteServiceProperties, Endpoint.instanceOf("test"), params);
        assertEquals("http://localhost:8080/test?param1=1&param2=2", url);
    }

    @Test
    public void testEncodeParamValue() {
        assertEquals("this+is+a+test", restClient.encodeParamValue("this is a test"));
        assertEquals("test%25", restClient.encodeParamValue("test%"));
    }


}