package com.ctm.providers.health.healthapply.model.request.fundData;

import java.util.function.Supplier;

public class ProductId implements Supplier<String> {

    private final String productId;

    public ProductId(final String productId) {
        this.productId = productId;
    }

    @Override
    public String get() {
        return productId;
    }
}
