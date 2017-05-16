package com.ctm.web.fuel.quote.model.pricebands;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

public class PriceBands {
    @JsonDeserialize
    @JsonProperty("T")
    private LocalDateTime lastTimestamp;

    @JsonDeserialize
    @JsonProperty("B")
    private List<Band> bands = Collections.EMPTY_LIST;

    @JsonDeserialize
    @JsonProperty("S")
    private List<SiteBand> siteBands = Collections.EMPTY_LIST;

    @JsonDeserialize
    @JsonProperty("N")
    private Boolean notModified;

    public LocalDateTime getLastTimestamp() {
        return lastTimestamp;
    }

    public List<Band> getBands() {
        return bands;
    }

    public List<SiteBand> getSiteBands() {
        return siteBands;
    }

    public Boolean getNotModified() {
        return notModified;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PriceBands that = (PriceBands) o;

        if (lastTimestamp != null ? !lastTimestamp.equals(that.lastTimestamp) : that.lastTimestamp != null)
            return false;
        if (bands != null ? !bands.equals(that.bands) : that.bands != null) return false;
        if (siteBands != null ? !siteBands.equals(that.siteBands) : that.siteBands != null) return false;
        return notModified != null ? notModified.equals(that.notModified) : that.notModified == null;

    }

    @Override
    public int hashCode() {
        int result = lastTimestamp != null ? lastTimestamp.hashCode() : 0;
        result = 31 * result + (bands != null ? bands.hashCode() : 0);
        result = 31 * result + (siteBands != null ? siteBands.hashCode() : 0);
        result = 31 * result + (notModified != null ? notModified.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "PriceBands{" +
                "lastTimestamp=" + lastTimestamp +
                ", bands=" + bands +
                ", siteBands=" + siteBands +
                ", notModified=" + notModified +
                '}';
    }
}
