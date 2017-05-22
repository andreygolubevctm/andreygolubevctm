package com.ctm.web.fuel.quote.model.averageprice;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CityAveragePrice {
    private Price averagePrice;
    private Price lowPrice;
    private Price highPrice;

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Price getAveragePrice() {
        return averagePrice;
    }

    @JsonProperty(value = "AvgPrice", access = JsonProperty.Access.WRITE_ONLY)
    private void setAveragePrice(Price averagePrice) {
        this.averagePrice = averagePrice;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Price getHighPrice() {
        return highPrice;
    }

    @JsonProperty(value = "HighPrice", access = JsonProperty.Access.WRITE_ONLY)
    private void setHighPrice(Price highPrice) {
        this.highPrice = highPrice;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    public Price getLowPrice() {
        return lowPrice;
    }

    @JsonProperty(value = "LowPrice", access = JsonProperty.Access.WRITE_ONLY)
    private void setLowPrice(Price lowPrice) {
        this.lowPrice = lowPrice;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        CityAveragePrice that = (CityAveragePrice) o;

        if (averagePrice != null ? !averagePrice.equals(that.averagePrice) : that.averagePrice != null) return false;
        if (lowPrice != null ? !lowPrice.equals(that.lowPrice) : that.lowPrice != null) return false;
        return highPrice != null ? highPrice.equals(that.highPrice) : that.highPrice == null;

    }

    @Override
    public int hashCode() {
        int result = averagePrice != null ? averagePrice.hashCode() : 0;
        result = 31 * result + (lowPrice != null ? lowPrice.hashCode() : 0);
        result = 31 * result + (highPrice != null ? highPrice.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "CityAveragePrice{" +
                "averagePrice=" + averagePrice +
                ", lowPrice=" + lowPrice +
                ", highPrice=" + highPrice +
                '}';
    }
}
