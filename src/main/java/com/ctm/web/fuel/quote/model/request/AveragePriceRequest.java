package com.ctm.web.fuel.quote.model.request;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.ALWAYS)
public class AveragePriceRequest {
    private Float lat;
    private Float lng;
    private Long fuelId;

    public Long getFuelId() {
        return fuelId;
    }

    public Float getLat() {
        return lat;
    }

    public Float getLng() {
        return lng;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        AveragePriceRequest that = (AveragePriceRequest) o;

        if (lat != null ? !lat.equals(that.lat) : that.lat != null) return false;
        if (lng != null ? !lng.equals(that.lng) : that.lng != null) return false;
        return fuelId != null ? fuelId.equals(that.fuelId) : that.fuelId == null;

    }

    @Override
    public int hashCode() {
        int result = lat != null ? lat.hashCode() : 0;
        result = 31 * result + (lng != null ? lng.hashCode() : 0);
        result = 31 * result + (fuelId != null ? fuelId.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "AveragePriceRequest{" +
                "fuelId=" + fuelId +
                ", lat=" + lat +
                ", lng=" + lng +
                '}';
    }
}
