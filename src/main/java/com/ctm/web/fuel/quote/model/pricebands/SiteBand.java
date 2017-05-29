package com.ctm.web.fuel.quote.model.pricebands;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.time.LocalDateTime;

public class SiteBand {
    @JsonDeserialize
    @JsonProperty("S")
    private Long id;

    @JsonDeserialize
    @JsonProperty("D")
    private Long d; // Not sure what it is

    @JsonDeserialize
    @JsonProperty("T")
    private LocalDateTime lastTimestamp;

    @JsonDeserialize
    @JsonProperty("C")
    private String collectionMethod;

    @JsonDeserialize
    @JsonProperty("B")
    private Long bandId;

    public Long getId() {
        return id;
    }

    public Long getD() {
        return d;
    }

    public LocalDateTime getLastTimestamp() {
        return lastTimestamp;
    }

    public String getCollectionMethod() {
        return collectionMethod;
    }

    public Long getBandId() {
        return bandId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        SiteBand siteBand = (SiteBand) o;

        if (id != null ? !id.equals(siteBand.id) : siteBand.id != null) return false;
        if (d != null ? !d.equals(siteBand.d) : siteBand.d != null) return false;
        if (lastTimestamp != null ? !lastTimestamp.equals(siteBand.lastTimestamp) : siteBand.lastTimestamp != null)
            return false;
        if (collectionMethod != null ? !collectionMethod.equals(siteBand.collectionMethod) : siteBand.collectionMethod != null)
            return false;
        return bandId != null ? bandId.equals(siteBand.bandId) : siteBand.bandId == null;

    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (d != null ? d.hashCode() : 0);
        result = 31 * result + (lastTimestamp != null ? lastTimestamp.hashCode() : 0);
        result = 31 * result + (collectionMethod != null ? collectionMethod.hashCode() : 0);
        result = 31 * result + (bandId != null ? bandId.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "SiteBand{" +
                "id=" + id +
                ", d=" + d +
                ", lastTimestamp=" + lastTimestamp +
                ", collectionMethod=" + collectionMethod +
                ", bandId=" + bandId +
                '}';
    }
}
