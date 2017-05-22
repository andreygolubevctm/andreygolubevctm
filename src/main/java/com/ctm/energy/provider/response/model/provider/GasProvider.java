package com.ctm.energy.provider.response.model.provider;

import com.ctm.energy.provider.response.model.types.ProviderName;
import com.ctm.interfaces.common.config.types.ProviderId;

public class GasProvider extends EnergyProvider {

    private GasProvider() {
    }

    public GasProvider(ProviderId providerId, ProviderName providerName) {
        super(providerId, providerName);
    }
}
