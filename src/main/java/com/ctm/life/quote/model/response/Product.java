package com.ctm.life.quote.model.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import javax.validation.constraints.NotNull;
import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Product {

    private String name;
    private String description;
    private String belowMinimum;
    private String stars;

    @NotNull
    private String pds;

    @NotNull
    private Premium premium;

    private Company company;
    public ProductDetails productDetails;

    /**
     * Used by jackson
     */
    @SuppressWarnings("unused")
    private Product() {

    }

    private Product(Builder builder) {
        name = builder.name;
        description = builder.description;
        belowMinimum = builder.belowMinimum;
        stars = builder.stars;
        pds = builder.pds;
        premium = builder.premium;
        company = builder.company;
        productDetails = builder.productDetails;
    }

    public Optional<ProductDetails> getProductDetails() {
        return Optional.ofNullable(productDetails);
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public Premium getPremium() {
        return premium;
    }

    public Company getCompany() {
        return company;
    }

    public String getPds() {
        return pds;
    }

    public String getBelowMinimum() {
        return belowMinimum;
    }

    public String getStars() {
        return stars;
    }

    public static final class Builder {
        private String name;
        private String description;
        private String belowMinimum;
        private String stars;
        private Premium premium;
        private Company company;
        private ProductDetails productDetails;
        private String pds;

        public Builder name(String val) {
            name = val;
            return this;
        }

        public Builder description(String val) {
            description = val;
            return this;
        }

        public Builder belowMinimum(String val) {
            belowMinimum = val;
            return this;
        }

        public Builder stars(String val) {
            stars = val;
            return this;
        }

        public Builder premium(Premium val) {
            premium = val;
            return this;
        }

        public Builder company(Company val) {
            company = val;
            return this;
        }

        public Builder productDetails(ProductDetails val) {
            productDetails = val;
            return this;
        }

        public Builder pds(String val) {
            pds = val;
            return this;
        }

        public Builder productDetails(Optional<ProductDetails> val) {
            productDetails = val.orElse(null);
            return this;
        }

        public Product build() {
            return new Product(this);
        }
    }
}
