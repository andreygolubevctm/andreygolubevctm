package com.ctm.web.fuel.quote.model.response;

import com.ctm.web.fuel.quote.model.pricebands.Band;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.List;

public class QuoteResponseInfo {
    @JsonSerialize
    private List<Band> bands;

    @JsonSerialize
    private String cityName;

    /* Jackson serialization */
    private QuoteResponseInfo() {
    }

    private QuoteResponseInfo(Builder builder) {
        bands = builder.bands;
        cityName = builder.cityName;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public List<Band> getBands() {
        return bands;
    }

    public String getCityName() {
        return cityName;
    }

    public static final class Builder {
        private List<Band> bands;
        private String cityName;

        private Builder() {
        }

        public Builder bands(List<Band> val) {
            bands = val;
            return this;
        }

        public Builder cityName(String val) {
            cityName = val;
            return this;
        }

        public QuoteResponseInfo build() {
            return new QuoteResponseInfo(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        QuoteResponseInfo that = (QuoteResponseInfo) o;

        if (bands != null ? !bands.equals(that.bands) : that.bands != null) return false;
        return cityName != null ? cityName.equals(that.cityName) : that.cityName == null;

    }

    @Override
    public int hashCode() {
        int result = bands != null ? bands.hashCode() : 0;
        result = 31 * result + (cityName != null ? cityName.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "QuoteResponseInfo{" +
                "bands=" + bands +
                ", cityName='" + cityName + '\'' +
                '}';
    }
}
