package com.ctm.web.fuel.quote.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CityCurrentDayAvgRequest {
    @JsonProperty("CityId")
    private Long cityId;

    @JsonProperty("FuelId")
    private Long fuelId;

    private CityCurrentDayAvgRequest(Builder builder) {
        cityId = builder.cityId;
        fuelId = builder.fuelId;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public Long getCityId() {
        return cityId;
    }

    public Long getFuelId() {
        return fuelId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        CityCurrentDayAvgRequest that = (CityCurrentDayAvgRequest) o;

        if (cityId != null ? !cityId.equals(that.cityId) : that.cityId != null) return false;
        return fuelId != null ? fuelId.equals(that.fuelId) : that.fuelId == null;

    }

    @Override
    public int hashCode() {
        int result = cityId != null ? cityId.hashCode() : 0;
        result = 31 * result + (fuelId != null ? fuelId.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "CityCurrentDayAvgRequest{" +
                "cityId=" + cityId +
                ", fuelId=" + fuelId +
                '}';
    }

    public static final class Builder {
        private Long cityId;
        private Long fuelId;

        private Builder() {
        }

        public Builder cityId(Long val) {
            cityId = val;
            return this;
        }

        public Builder fuelId(Long val) {
            fuelId = val;
            return this;
        }

        public CityCurrentDayAvgRequest build() {
            return new CityCurrentDayAvgRequest(this);
        }
    }
}
