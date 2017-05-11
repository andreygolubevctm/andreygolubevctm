package com.ctm.web.fuel.quote.model.sitedetails;

import com.ctm.fuelquote.model.citysites.Site;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDateTime;
import java.util.List;

public class FullSiteDetails {
    @JsonProperty("T")
    private LocalDateTime lastTimestamp;

    @JsonProperty("S")
    private List<Site> sites;

    @JsonProperty("N")
    private Boolean notModified;

    public LocalDateTime getLastTimestamp() {
        return lastTimestamp;
    }

    public List<Site> getSites() {
        return sites;
    }

    public Boolean getNotModified() {
        return notModified;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        FullSiteDetails that = (FullSiteDetails) o;

        if (lastTimestamp != null ? !lastTimestamp.equals(that.lastTimestamp) : that.lastTimestamp != null)
            return false;
        if (sites != null ? !sites.equals(that.sites) : that.sites != null) return false;
        return notModified != null ? notModified.equals(that.notModified) : that.notModified == null;

    }

    @Override
    public int hashCode() {
        int result = lastTimestamp != null ? lastTimestamp.hashCode() : 0;
        result = 31 * result + (sites != null ? sites.hashCode() : 0);
        result = 31 * result + (notModified != null ? notModified.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "FullSiteDetails{" +
                "lastTimestamp=" + lastTimestamp +
                ", sites=" + sites +
                ", notModified=" + notModified +
                '}';
    }
}
