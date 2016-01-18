package com.ctm.web.energy.provider.adapter;

import com.ctm.energy.provider.response.model.EnergyProviders;
import com.ctm.energy.provider.response.model.provider.ElectricityProvider;
import com.ctm.energy.provider.response.model.provider.GasProvider;
import com.ctm.energy.provider.response.model.types.ElectricityTariff;
import com.ctm.energy.provider.response.model.types.ProviderName;
import com.ctm.interfaces.common.config.types.ProviderId;
import com.ctm.web.core.providers.model.QuoteResponse;
import com.ctm.web.energy.form.response.model.EnergyProvidersWebResponse;
import com.ctm.web.energy.model.EnergyProviderResponse;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static java.util.Arrays.asList;
import static java.util.Collections.singletonList;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class EnergyProviderServiceResponseAdapterTest {

    @Mock
    EnergyProviderResponse response;
    @Mock
    QuoteResponse<EnergyProviders> quoteResponse;
    @Mock
    private EnergyProviders energyProviders;

    private EnergyProviderServiceResponseAdapter adapter = new EnergyProviderServiceResponseAdapter();

    @Before
    public void setup() throws Exception {
        initMocks(this);
        when(response.getPayload()).thenReturn(quoteResponse);
        when(quoteResponse.getQuotes()).thenReturn(singletonList(energyProviders));
    }

    @Test
    public void adaptEmpty() throws Exception {
        final EnergyProvidersWebResponse webResponse = adapter.adapt(response);
        assertTrue(webResponse.getElectricityProviders().isEmpty());
        assertTrue(webResponse.getGasProviders().isEmpty());
        assertEquals("", webResponse.getElectricityTariff());
    }

    @Test
    public void adapt() throws Exception {
        when(energyProviders.getElectricityTariff()).thenReturn(ElectricityTariff.instanceOf("8400"));
        when(energyProviders.getElectricityProviders()).thenReturn(asList(
                new ElectricityProvider(ProviderId.instanceOf(1), ProviderName.instanceOf("Origin")),
                new ElectricityProvider(ProviderId.instanceOf(2), ProviderName.instanceOf("Energy Australia"))));
        when(energyProviders.getGasProviders()).thenReturn(
                singletonList(new GasProvider(ProviderId.instanceOf(1), ProviderName.instanceOf("Origin"))));
        final EnergyProvidersWebResponse webResponse = adapter.adapt(response);
        assertEquals(2, webResponse.getElectricityProviders().size());
        assertEquals(1, webResponse.getGasProviders().size());
        assertEquals("8400", webResponse.getElectricityTariff());
    }

}