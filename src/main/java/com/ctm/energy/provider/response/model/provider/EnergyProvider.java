package com.ctm.energy.provider.response.model.provider;

import com.ctm.energy.provider.response.model.types.ProviderName;
import com.ctm.interfaces.common.config.types.ProviderId;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public abstract class EnergyProvider {

    @JsonSerialize(using = ValueSerializer.class)
    private ProviderId providerId;

    @JsonSerialize(using = ValueSerializer.class)
    private ProviderName providerName;

    // JSON Constructor
    protected EnergyProvider() {
    }

    public EnergyProvider(ProviderId providerId, ProviderName providerName) {
        this.providerId = providerId;
        this.providerName = providerName;
    }

    public ProviderId getProviderId() {
        return providerId;
    }

    public ProviderName getProviderName() {
        return providerName;
    }

}
