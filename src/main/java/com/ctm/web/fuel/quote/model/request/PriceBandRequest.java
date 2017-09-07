package com.ctm.web.fuel.quote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.time.LocalDateTime;

public class PriceBandRequest {
    @JsonSerialize
    private LocalDateTime lastTimestamp;

    @JsonSerialize
    private Long cityId;

    @JsonSerialize
    private Long fuelId;

    private PriceBandRequest(Builder builder) {
        lastTimestamp = builder.lastTimestamp;
        cityId = builder.cityId;
        fuelId = builder.fuelId;
    }

    public static Builder newBuilder() {
        return new Builder();
    }


    @Override
    public String toString() {
        return "PriceBandRequest{" +
                "lastTimestamp=" + lastTimestamp +
                ", cityId=" + cityId +
                ", fuelId=" + fuelId +
                '}';
    }

    public static final class Builder {
        private LocalDateTime lastTimestamp;
        private Long cityId;
        private Long fuelId;

        private Builder() {
        }

        public Builder lastTimestamp(LocalDateTime val) {
            lastTimestamp = val;
            return this;
        }

        public Builder cityId(Long val) {
            cityId = val;
            return this;
        }

        public Builder fuelId(Long val) {
            fuelId = val;
            return this;
        }

        public PriceBandRequest build() {
            return new PriceBandRequest(this);
        }
    }
}
