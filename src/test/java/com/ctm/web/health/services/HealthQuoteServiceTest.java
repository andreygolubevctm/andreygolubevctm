package com.ctm.web.health.services;

import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.ProviderFilter;
import com.ctm.web.core.services.EnvironmentService;
import org.junit.Test;

import static org.mockito.Mockito.*;

public class HealthQuoteServiceTest {

    private HealthQuoteService healthQuoteService = new HealthQuoteService(null, null);

    @Test
    public void testFilterLocalhost() throws Exception {
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(null);
    }

    @Test(expected = RouterException.class)
    public void testFilterNXS() throws Exception {
        EnvironmentService.setEnvironment("nxs");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(null);
    }

    @Test(expected = RouterException.class)
    public void testFilterInvalidProviderKey() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("12334");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
    }

    @Test
    public void testFilterAU() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("au_74815263");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("1");
    }

    @Test
    public void testFilterHCF() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("hcf_7895123");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("2");
    }

    @Test
    public void testFilterGMHBA() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("gmhba_74851253");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("5");
    }

    @Test
    public void testFilterFRANK() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("frank_7152463");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("8");
    }
    @Test
    public void testFilterAHM() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("ahm_685347");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("9");
    }
    @Test
    public void testFilterCBHS() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("cbhs_597125");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("10");
    }
    @Test
    public void testFilterHIF() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("hif_87364556");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("11");
    }

    @Test
    public void testFilterCUA() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("cua_089105165");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("12");
    }

    @Test
    public void testFilterCTM() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("ctm_123456789");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("14");
    }

    @Test
    public void testFilterBUP() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("bup_744568719");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("15");
    }

    @Test
    public void testFilterBUD() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("bud_296587056");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("54");
    }

    @Test
    public void testFilterQCHF() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("qchf_63422354");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("16");
    }

    @Test
    public void testFilterNHB() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("nhb_42694269");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("17");
    }

    @Test
    public void testFilterHBF() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("hbf_89564575");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("18");
    }

    @Test
    public void testFilterQTU() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("qtu_24642736");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("19");
    }

    @Test
    public void testFilterWFD() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("wfd_456912");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("7");
    }

    @Test
    public void testFilterHEA() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("hea_8281277");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("456");
    }

    @Test
    public void testFilterQTS() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("qts_42055178");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("462");
    }

    @Test
    public void testFilterUHF() throws Exception {
        final ProviderFilter providerFilter = mock(ProviderFilter.class);
        when(providerFilter.getProviderKey()).thenReturn("uhf_59564576");
        EnvironmentService.setEnvironment("localhost");
        healthQuoteService = new HealthQuoteService(null, null);
        healthQuoteService.setFilter(providerFilter);
        verify(providerFilter, atLeastOnce()).getProviderKey();
        verify(providerFilter).setSingleProvider("463");
    }

}