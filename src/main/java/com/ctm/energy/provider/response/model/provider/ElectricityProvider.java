package com.ctm.energy.provider.response.model.provider;

import com.ctm.energy.provider.response.model.types.ProviderName;
import com.ctm.interfaces.common.config.types.ProviderId;

public class ElectricityProvider extends EnergyProvider {

    private ElectricityProvider() {
    }

    public ElectricityProvider(ProviderId providerId, ProviderName providerName) {
        super(providerId, providerName);
    }
}
