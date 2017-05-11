package com.ctm.web.fuel.quote.model.citysites;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.time.LocalDateTime;
import java.util.List;

public class City {
    @JsonDeserialize
    @JsonProperty("C")
    private Long id;

    @JsonDeserialize
    @JsonProperty("T")
    private LocalDateTime lastTimestamp;

    @JsonDeserialize
    @JsonProperty("S")
    private List<Site> sites;

    private City() {}

    public Long getId() {
        return id;
    }

    public LocalDateTime getLastTimestamp() {
        return lastTimestamp;
    }

    public List<Site> getSites() {
        return sites;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        City city = (City) o;

        if (id != null ? !id.equals(city.id) : city.id != null) return false;
        if (lastTimestamp != null ? !lastTimestamp.equals(city.lastTimestamp) : city.lastTimestamp != null)
            return false;
        return sites != null ? sites.equals(city.sites) : city.sites == null;

    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (lastTimestamp != null ? lastTimestamp.hashCode() : 0);
        result = 31 * result + (sites != null ? sites.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "City{" +
                "id=" + id +
                ", lastTimestamp=" + lastTimestamp +
                ", sites=" + sites +
                '}';
    }
}
