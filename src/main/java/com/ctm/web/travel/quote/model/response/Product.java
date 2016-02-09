package com.ctm.web.travel.quote.model.response;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class Product {

    public final String shortTitle;

    public final String longTitle;

    @NotNull
    @Size(min=1)
    public final String description;

    @NotNull
    @Size(min=1)
    public final String pdsUrl;

    @NotNull
    public final Integer maxTripDuration;

    // empty constructor needed by jackson
    @SuppressWarnings("UnusedDeclaration")
    private Product() {
        this.shortTitle = "";
        this.longTitle = "";
        this.description = "";
        this.pdsUrl = "";
        this.maxTripDuration = null;
    }


    @Override
    @SuppressWarnings("RedundantIfStatement")
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final Product product = (Product) o;

        if (description != null ? !description.equals(product.description) : product.description != null) return false;
        if (longTitle != null ? !longTitle.equals(product.longTitle) : product.longTitle != null) return false;
        if (pdsUrl != null ? !pdsUrl.equals(product.pdsUrl) : product.pdsUrl != null) return false;
        if (shortTitle != null ? !shortTitle.equals(product.shortTitle) : product.shortTitle != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = shortTitle != null ? shortTitle.hashCode() : 0;
        result = 31 * result + (longTitle != null ? longTitle.hashCode() : 0);
        result = 31 * result + (description != null ? description.hashCode() : 0);
        result = 31 * result + (pdsUrl != null ? pdsUrl.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "Product{" +
                "shortTitle='" + shortTitle + '\'' +
                ", longTitle='" + longTitle + '\'' +
                ", description='" + description + '\'' +
                ", pdsUrl='" + pdsUrl + '\'' +
                '}';
    }

    public static Product unavailable() {
        return new Product();
    }

    public String getShortTitle() {
        return shortTitle;
    }

    public String getLongTitle() {
        return longTitle;
    }

    public String getDescription() {
        return description;
    }

    public String getPdsUrl() {
        return pdsUrl;
    }

    public Integer getMaxTripDuration() {
        return maxTripDuration;
    }
}
