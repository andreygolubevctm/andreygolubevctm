package com.ctm.web.energy.provider.adapter;

import com.ctm.energy.provider.request.model.EnergyProviderRequest;
import com.ctm.energy.provider.request.model.types.PostCode;
import com.ctm.energy.provider.request.model.types.Suburb;
import com.ctm.web.energy.form.model.EnergyProviderWebRequest;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class EnergyProviderServiceRequestAdapter implements WebRequestAdapter<EnergyProviderWebRequest, EnergyProviderRequest> {

    @Override
    public EnergyProviderRequest adapt(EnergyProviderWebRequest request) {
        return new EnergyProviderRequest(
                PostCode.instanceOf(
                        Optional.ofNullable(
                                request.getPostcode())
                                .orElseThrow(() -> new IllegalArgumentException("postcode missing"))),
                Suburb.instanceOf(""));
    }
}
