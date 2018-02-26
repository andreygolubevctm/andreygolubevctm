package com.ctm.web.simples.admin.model.capping.product;

import com.ctm.web.simples.admin.services.HealthProductCappingService;

import java.util.Arrays;
import java.util.Optional;

public enum ProductCappingLimitType {
    Monthly("Monthly"), Daily("Daily");
    public final String text;

    ProductCappingLimitType(String text) {
        this.text = text;
    }

    public static Optional<ProductCappingLimitType> fromString(String value) {
        return Arrays.stream(ProductCappingLimitType.values())
                .filter(c -> c.text.equalsIgnoreCase(value))
                .findFirst();
    }

}
