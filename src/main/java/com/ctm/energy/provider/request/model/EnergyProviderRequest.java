package com.ctm.energy.provider.request.model;

import com.ctm.energy.provider.request.model.types.PostCode;
import com.ctm.energy.provider.request.model.types.Suburb;
import com.ctm.interfaces.common.aggregator.request.QuoteRequest;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import javax.validation.constraints.NotNull;

public class EnergyProviderRequest implements QuoteRequest {

    @NotNull
    @JsonSerialize(using = ValueSerializer.class)
    private PostCode postCode;

    @NotNull
    @JsonSerialize(using = ValueSerializer.class)
    private Suburb suburb;

    // JSON constructor
    private EnergyProviderRequest() {
    }

    public EnergyProviderRequest(PostCode postCode, Suburb suburb) {
        this.postCode = postCode;
        this.suburb = suburb;
    }

    public PostCode getPostCode() {
        return postCode;
    }

    public Suburb getSuburb() {
        return suburb;
    }
}
