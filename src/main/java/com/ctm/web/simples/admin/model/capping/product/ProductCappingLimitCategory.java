package com.ctm.web.simples.admin.model.capping.product;

import java.util.Arrays;
import java.util.Optional;

public enum ProductCappingLimitCategory {
    HARD("H"), SOFT("S");

    public final String text;

    ProductCappingLimitCategory(String text) {
        this.text = text;
    }

    public static Optional<ProductCappingLimitCategory> fromString(String value) {
        return Arrays.stream(ProductCappingLimitCategory.values())
                .filter(c -> c.text.equalsIgnoreCase(value))
                .findFirst();
    }

}
