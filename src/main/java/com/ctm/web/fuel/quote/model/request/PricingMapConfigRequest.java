package com.ctm.web.fuel.quote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.time.LocalDateTime;

public class PricingMapConfigRequest {
    @JsonSerialize
    private LocalDateTime lastTimestamp;

    private PricingMapConfigRequest() {}

    public PricingMapConfigRequest(final LocalDateTime lastTimestamp) {
        this.lastTimestamp = lastTimestamp;
    }

    public LocalDateTime getLastTimestamp() {
        return lastTimestamp;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PricingMapConfigRequest that = (PricingMapConfigRequest) o;

        return lastTimestamp != null ? lastTimestamp.equals(that.lastTimestamp) : that.lastTimestamp == null;

    }

    @Override
    public int hashCode() {
        return lastTimestamp != null ? lastTimestamp.hashCode() : 0;
    }

    @Override
    public String toString() {
        return "PricingMapConfig{" +
                "lastTimestamp=" + lastTimestamp +
                '}';
    }
}
