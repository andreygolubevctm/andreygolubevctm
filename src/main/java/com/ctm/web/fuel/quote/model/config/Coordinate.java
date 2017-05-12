package com.ctm.web.fuel.quote.model.config;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import javax.validation.constraints.NotNull;

@ApiModel
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Coordinate {
    @ApiModelProperty(name = "Lat", required = true)
    @JsonProperty("Lat")
    @NotNull
    private Float lat;

    @ApiModelProperty(name = "Long", required = true)
    @JsonProperty("Lng")
    @NotNull
    private Float lng;

    private Coordinate() {}

    private Coordinate(Builder builder) {
        lat = builder.lat;
        lng = builder.lng;
    }

    public static Builder newBuilder() {
        return new Builder();
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

        Coordinate that = (Coordinate) o;

        if (lat != null ? !lat.equals(that.lat) : that.lat != null) return false;
        return lng != null ? lng.equals(that.lng) : that.lng == null;

    }

    @Override
    public int hashCode() {
        int result = lat != null ? lat.hashCode() : 0;
        result = 31 * result + (lng != null ? lng.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "Coordinate{" +
                "lat=" + lat +
                ", lng=" + lng +
                '}';
    }

    public static final class Builder {
        private Float lat;
        private Float lng;

        private Builder() {
        }

        public Builder lat(Float val) {
            lat = val;
            return this;
        }

        public Builder lng(Float val) {
            lng = val;
            return this;
        }

        public Coordinate build() {
            return new Coordinate(this);
        }
    }
}
