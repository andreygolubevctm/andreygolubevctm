package com.ctm.energy.product.request.model;

import com.ctm.interfaces.common.aggregator.request.QuoteRequest;
import com.ctm.interfaces.common.types.ProductId;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import javax.validation.constraints.NotNull;

public class EnergyProductRequest implements QuoteRequest {

    @NotNull
    @JsonSerialize(using = ValueSerializer.class)
    private ProductId productId;

    // JSON constructor
    private EnergyProductRequest() {
    }

    public EnergyProductRequest(final ProductId productId) {
        this.productId = productId;
    }

    public ProductId getProductId() {
        return productId;
    }
}
