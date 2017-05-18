package com.ctm.web.fuel.quote.model.averageprice;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.ZonedDateTime;

public class Price {
    private Float price;
    private ZonedDateTime priceDateUtc;

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Float getPrice() {
        return price;
    }

    @JsonProperty(value = "Price", access = JsonProperty.Access.WRITE_ONLY)
    private void setPrice(Float price) {
        this.price = price;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public ZonedDateTime getPriceDateUtc() {
        return priceDateUtc;
    }

    @JsonProperty(value = "PriceDateUtc", access = JsonProperty.Access.WRITE_ONLY)
    private void setPriceDateUtc(ZonedDateTime priceDateUtc) {
        this.priceDateUtc = priceDateUtc;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Price that = (Price) o;

        if (price != null ? !price.equals(that.price) : that.price != null) return false;
        return priceDateUtc != null ? priceDateUtc.equals(that.priceDateUtc) : that.priceDateUtc == null;

    }

    @Override
    public int hashCode() {
        int result = price != null ? price.hashCode() : 0;
        result = 31 * result + (priceDateUtc != null ? priceDateUtc.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "AveragePrice{" +
                "price=" + price +
                ", priceDateUtc=" + priceDateUtc +
                '}';
    }
}

