package com.ctm.web.health.services;

import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.ProviderFilter;
import com.ctm.web.core.services.EnvironmentService;
import org.junit.Test;

import static org.mockito.Mockito.*;

public class HealthQuoteServiceTest {

    private HealthQuoteService healthQuoteService = new HealthQuoteService();

    @Test
    public void testFilterLocalhost() throws Exception {
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService();
        healthQuoteService.setFilter(null);
    }

    @Test(expected = RouterException.class)
    public void testFilterNXS() throws Exception {
        EnvironmentService.setEnvironment("nxs");
        healthQuoteService = new HealthQuoteService();
        healthQuoteService.setFilter(null);
    }

    @Test(expected = RouterException.class)
    public void testFilterInvalidProviderKey() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("12334");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService();
        healthQuoteService.setFilter(providerFilter);
    }

    @Test
    public void testFilterAU() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("au_74815263");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService();
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("1");
    }

    @Test
    public void testFilterCAU() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("cua_089105165");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService();
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("12");
    }

}