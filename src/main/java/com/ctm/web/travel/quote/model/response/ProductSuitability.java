package com.ctm.web.travel.quote.model.response;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Objects;

public class ProductSuitability {


    public final String title;
    public final  String productSuitabilityStatement;

    @JsonCreator
    public ProductSuitability(@JsonProperty("title") String title,@JsonProperty("productSuitabilityStatement") String productSuitabilityStatement) {
        this.title = title;
        this.productSuitabilityStatement = productSuitabilityStatement;
    }

    public ProductSuitability() {
        this.title = "";
        this.productSuitabilityStatement = "";
    }

    @Override
    @SuppressWarnings("RedundantIfStatement")
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final ProductSuitability productSuitability = (ProductSuitability) o;

        if (!Objects.equals(title, productSuitability.title)) return false;
        if (!Objects.equals(productSuitabilityStatement, productSuitability.productSuitabilityStatement)) return false;

        return true;
    }

    @Override
    public String toString() {
        return "ProductSuitability{" +
                "title='" + title + '\'' +
                ", productSuitabilityStatement='" + productSuitabilityStatement + '\'' +
                '}';
    }

    public String getTitle() {
        return title;
    }

    public String getProductSuitabilityStatement() {
        return productSuitabilityStatement;
    }


}
