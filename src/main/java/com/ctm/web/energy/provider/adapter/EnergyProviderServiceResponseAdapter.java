package com.ctm.web.energy.provider.adapter;

import com.ctm.energy.provider.response.model.EnergyProviders;
import com.ctm.energy.provider.response.model.provider.ElectricityProvider;
import com.ctm.energy.provider.response.model.provider.EnergyProvider;
import com.ctm.energy.provider.response.model.provider.GasProvider;
import com.ctm.energy.provider.response.model.types.ElectricityTariff;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.energy.form.response.model.EnergyProvidersWebResponse;
import com.ctm.web.energy.form.response.model.Provider;
import com.ctm.web.energy.quote.adapter.WebResponseAdapter;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

import static java.util.Collections.emptyList;
import static java.util.stream.Collectors.toList;

@Component
public class EnergyProviderServiceResponseAdapter implements WebResponseAdapter<EnergyProvidersWebResponse, Response<EnergyProviders>> {

    @Override
    public EnergyProvidersWebResponse adapt(Response<EnergyProviders> energyProvidersResponse) {
        EnergyProvidersWebResponse response = new EnergyProvidersWebResponse();
        final EnergyProviders energyProviders = energyProvidersResponse.getPayload().getQuotes().get(0);
        response.setElectricityProviders(createElectricityProviders(energyProviders.getElectricityProviders()));
        response.setElectricityTariff(Optional.ofNullable(energyProviders.getElectricityTariff())
                .orElse(ElectricityTariff.instanceOf("")).get());
        response.setGasProviders(createGasProviders(energyProviders.getGasProviders()));
        return response;
    }

    private List<Provider> createGasProviders(List<GasProvider> gasProviders) {
        return Optional.ofNullable(gasProviders)
                .orElse(emptyList())
                .stream()
                .map(this::createProvider)
                .collect(toList());
    }

    private List<Provider> createElectricityProviders(List<ElectricityProvider> electricityProviders) {
        return Optional.ofNullable(electricityProviders)
                .orElse(emptyList())
                .stream()
                .map(this::createProvider)
                .collect(toList());
    }

    private Provider createProvider(EnergyProvider p) {
        Provider provider = new Provider();
        provider.setId(p.getProviderId().get());
        provider.setName(p.getProviderName().get());
        return provider;
    }
}
