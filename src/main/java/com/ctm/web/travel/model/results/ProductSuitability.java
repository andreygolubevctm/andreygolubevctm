package com.ctm.web.travel.model.results;

import lombok.Getter;

@Getter
public class ProductSuitability {

    private final String title;
    private final  String productSuitabilityStatement;

    public ProductSuitability( final  String title, final String productSuitabilityStatement) {
        this.title = title;
        this.productSuitabilityStatement = productSuitabilityStatement;
    }

}
