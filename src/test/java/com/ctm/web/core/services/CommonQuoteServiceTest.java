package com.ctm.web.core.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.ProviderFilter;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.formData.RequestWithQuote;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.validation.Name;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import java.util.Collections;
import java.util.Optional;
import java.util.function.Supplier;

import static com.ctm.web.core.model.settings.ConfigSetting.ALL_BRANDS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.ALL_PROVIDERS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope.SERVICE;
import static com.ctm.web.core.services.CommonQuoteService.*;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;

public class CommonQuoteServiceTest {

    private CommonQuoteService commonQuoteService;

    @Mock
    private ProviderFilterDao providerFilterDao;

    @Mock
    private QuoteServiceProperties quoteServiceProperties;

    @Mock
    private SimpleConnection simpleConnection;

    @Mock
    private ObjectMapper objectMapper;

    @Mock
    private ServiceConfiguration serviceConfiguration;

    @Before
    public void setup() throws Exception {
        initMocks(this);

        EnvironmentService.setEnvironment("localhost");
        commonQuoteService = spy(new CommonQuoteService(providerFilterDao, objectMapper) {});

    }

    @Test(expected = RouterException.class)
    public void testEmptyRequest() throws Exception {
        isValid(() -> commonQuoteService.validateRequest(null, null));
    }

    @Test(expected = RouterException.class)
    public void testEmptyQuoteRequest() throws Exception {
        final RequestWithQuote request = mock(RequestWithQuote.class);
        isValid(() -> commonQuoteService.validateRequest(request, "AnyVertical"));
    }

    @Test
    public void testValidRequest() throws Exception {
        final RequestWithQuote request = mock(RequestWithQuote.class);
        when(request.getQuote()).thenReturn(new Quote("name"));
        isValid(() -> commonQuoteService.validateRequest(request, "AnyVertical"));
    }

    @Test(expected = RouterException.class)
    public void testInvalidRequest() throws Exception {
        final RequestWithQuote request = mock(RequestWithQuote.class);
        when(request.getQuote()).thenReturn(new Quote("name??"));
        isInvalid(() -> commonQuoteService.validateRequest(request, "AnyVertical"));
    }

    @Test
    public void testSetFilterEmpty() throws Exception {
        ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("");
        when(providerFilter.getAuthToken()).thenReturn("");
        commonQuoteService.setFilter(providerFilter);

        verify(providerFilter, times(1)).getProviderKey();
        verify(providerFilter, times(1)).getAuthToken();
        verify(providerFilter, never()).setSingleProvider(anyString());
        verify(providerFilter, never()).setProviders(anyList());

    }

    @Test
    public void testSetFilterWithProviderKey() throws Exception {
        ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("anyKey");

        when(providerFilterDao.getProviderDetails("anyKey")).thenReturn("anyProviderKey");

        commonQuoteService.setFilter(providerFilter);

        verify(providerFilter, times(2)).getProviderKey();
        verify(providerFilter, never()).getAuthToken();
        verify(providerFilter, times(1)).setSingleProvider("anyProviderKey");
        verify(providerFilter, never()).setProviders(anyList());

    }

    @Test(expected = RouterException.class)
    public void testSetFilterWithProviderKeyException() throws Exception {
        ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("anyKey");

        when(providerFilterDao.getProviderDetails("anyKey")).thenReturn(null);

        commonQuoteService.setFilter(providerFilter);
    }

    @Test
    public void testSetFilterWithAuthToken() throws Exception {
        ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("");
        when(providerFilter.getAuthToken()).thenReturn("anyKey");

        when(providerFilterDao.getProviderDetailsByAuthToken("anyKey")).thenReturn(Collections.singletonList("anyProviderKey"));

        commonQuoteService.setFilter(providerFilter);

        verify(providerFilter, times(1)).getProviderKey();
        verify(providerFilter, times(2)).getAuthToken();
        verify(providerFilter, never()).setSingleProvider(anyString());
        verify(providerFilter, times(1)).setProviders(Collections.singletonList("anyProviderKey"));

    }

    @Test(expected = RouterException.class)
    public void testSetFilterWithAuthTokenException() throws Exception {
        ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("");
        when(providerFilter.getAuthToken()).thenReturn("anyKey");

        when(providerFilterDao.getProviderDetailsByAuthToken("anyKey")).thenReturn(Collections.emptyList());

        commonQuoteService.setFilter(providerFilter);

    }

    @Test(expected = RouterException.class)
    public void testSetFilterNXS() throws Exception {
        ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("");
        when(providerFilter.getAuthToken()).thenReturn("");
        EnvironmentService.setEnvironment("nxs");
        commonQuoteService.setFilter(providerFilter);
    }

    @Test
    public void testSendRequest() throws Exception {
        Brand brand = mock(Brand.class);
        Request request = mock(Request.class);
        Object payload = mock(Object.class);
        Object responseObject = mock(Object.class);
        Vertical.VerticalType verticalType = Vertical.VerticalType.TRAVEL;
        when(quoteServiceProperties.getServiceUrl()).thenReturn("http://anyURL");
        when(simpleConnection.get(anyString())).thenReturn("response message");
        when(objectMapper.readValue(anyString(), any(JavaType.class))).thenReturn(responseObject);

        doReturn(simpleConnection).when(commonQuoteService).getSimpleConnection(any(QuoteServiceProperties.class), anyString());
        doReturn(quoteServiceProperties).when(commonQuoteService).getQuoteServiceProperties("anyService", brand, verticalType.getCode(), Optional.empty());

        final Object response = commonQuoteService.sendRequest(brand, verticalType, "anyService", Endpoint.QUOTE, request, payload, Object.class);

        assertEquals(responseObject, response);

        verify(quoteServiceProperties, times(1)).getServiceUrl();
        verify(simpleConnection, times(1)).get("http://anyURL/quote");
        verify(objectMapper, times(1)).readValue(eq("response message"), any(JavaType.class));

    }

    @Test(expected = RouterException.class)
    public void testSendRequestEmptyResponse() throws Exception {
        Brand brand = mock(Brand.class);
        Request request = mock(Request.class);
        Object payload = mock(Object.class);
        Object responseObject = mock(Object.class);
        Vertical.VerticalType verticalType = Vertical.VerticalType.TRAVEL;
        when(quoteServiceProperties.getServiceUrl()).thenReturn("http://anyURL");
        when(simpleConnection.get(anyString())).thenReturn(null);

        doReturn(simpleConnection).when(commonQuoteService).getSimpleConnection(any(QuoteServiceProperties.class), anyString());
        doReturn(quoteServiceProperties).when(commonQuoteService).getQuoteServiceProperties("anyService", brand, verticalType.getCode(), Optional.empty());

        final Object response = commonQuoteService.sendRequest(brand, verticalType, "anyService", Endpoint.QUOTE, request, payload, Object.class);

        assertEquals(responseObject, response);
    }

    @Test
    public void testQuoteServiceProperties() throws Exception {
        Brand brand = mock(Brand.class);
        Vertical.VerticalType verticalType = Vertical.VerticalType.TRAVEL;
        doReturn(serviceConfiguration).when(commonQuoteService).getServiceConfiguration("anyService", brand, verticalType.getCode());
        Vertical vertical = mock(Vertical.class);

        when(serviceConfiguration.getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("http://currentUrl");
        when(serviceConfiguration.getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("debugPath");
        when(serviceConfiguration.getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("100");

        final QuoteServiceProperties serviceProperties = commonQuoteService.getQuoteServiceProperties("anyService", brand, verticalType.getCode(), Optional.empty());

        assertEquals("http://currentUrl", serviceProperties.getServiceUrl());
        assertEquals("debugPath", serviceProperties.getDebugPath());
        assertEquals(100, serviceProperties.getTimeout());

        verify(serviceConfiguration, times(1)).getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
        verify(serviceConfiguration, times(1)).getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
        verify(serviceConfiguration, times(1)).getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE);

    }

    @Test
    public void testQuoteServicePropertiesWithEnvironmentOverride() throws Exception {
        Brand brand = mock(Brand.class);
        Vertical.VerticalType verticalType = Vertical.VerticalType.TRAVEL;
        doReturn(serviceConfiguration).when(commonQuoteService).getServiceConfiguration("anyService", brand, verticalType.getCode());

        when(serviceConfiguration.getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("http://currentUrl");
        when(serviceConfiguration.getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("debugPath");
        when(serviceConfiguration.getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("100");

        final QuoteServiceProperties serviceProperties = commonQuoteService.getQuoteServiceProperties("anyService", brand, verticalType.getCode(), Optional.of("http://newUrl"));

        assertEquals("http://newUrl", serviceProperties.getServiceUrl());
        assertEquals("debugPath", serviceProperties.getDebugPath());
        assertEquals(100, serviceProperties.getTimeout());

        verify(serviceConfiguration, times(1)).getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
        verify(serviceConfiguration, times(1)).getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
        verify(serviceConfiguration, times(1)).getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE);

    }

    @Test
    public void testQuoteServicePropertiesWithNoEnvironmentOverride() throws Exception {
        Brand brand = mock(Brand.class);
        Vertical.VerticalType verticalType = Vertical.VerticalType.TRAVEL;
        doReturn(serviceConfiguration).when(commonQuoteService).getServiceConfiguration("anyService", brand, verticalType.getCode());

        EnvironmentService.setEnvironment("nxs");

        when(serviceConfiguration.getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("http://currentUrl");
        when(serviceConfiguration.getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("debugPath");
        when(serviceConfiguration.getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE)).thenReturn("100");

        final QuoteServiceProperties serviceProperties = commonQuoteService.getQuoteServiceProperties("anyService", brand, verticalType.getCode(), Optional.of("http://newUrl"));

        assertEquals("http://currentUrl", serviceProperties.getServiceUrl());
        assertEquals("debugPath", serviceProperties.getDebugPath());
        assertEquals(100, serviceProperties.getTimeout());

        verify(serviceConfiguration, times(1)).getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
        verify(serviceConfiguration, times(1)).getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
        verify(serviceConfiguration, times(1)).getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE);

    }

    private void isInvalid(Supplier<Boolean> supplier) {
        try {
            supplier.get();
        } catch (Exception e) {
            assertNotNull(e);
            throw e;
        }
    }

    private void isValid(Supplier<Boolean> supplier) {
        assertTrue(supplier.get());
    }

    public class Quote {
        @Name
        private final String name;

        public Quote(final String name) {
            this.name = name;
        }

        public String getName() {
            return name;
        }
    }

}