package com.ctm.web.fuel.quote.model.config;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.time.ZonedDateTime;
import java.util.List;

public class PricingMapConfig {
    @JsonDeserialize
    @JsonProperty("T")
    private ZonedDateTime localDate;

    @JsonDeserialize
    @JsonProperty("C")
    private List<CityConfig> cities;

    @JsonDeserialize
    @JsonProperty("F")
    private List<FuelConfig> fuelConfigs;

    @JsonDeserialize
    @JsonProperty("CCM")
    private Long configCacheMinutes;

    @JsonDeserialize
    @JsonProperty("SCM")
    private Long sitesCacheMinutes;

    @JsonDeserialize
    @JsonProperty("PCM")
    private Long priceCacheMinutes;

    @JsonDeserialize
    @JsonProperty("N")
    private Boolean notModified;

    public ZonedDateTime getLocalDate() {
        return localDate;
    }

    public List<CityConfig> getCities() {
        return cities;
    }

    public List<FuelConfig> getFuelConfigs() {
        return fuelConfigs;
    }

    public Long getConfigCacheMinutes() {
        return configCacheMinutes;
    }

    public Long getSitesCacheMinutes() {
        return sitesCacheMinutes;
    }

    public Long getPriceCacheMinutes() {
        return priceCacheMinutes;
    }

    public Boolean getNotModified() {
        return notModified;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PricingMapConfig that = (PricingMapConfig) o;

        if (localDate != null ? !localDate.equals(that.localDate) : that.localDate != null) return false;
        if (cities != null ? !cities.equals(that.cities) : that.cities != null) return false;
        if (fuelConfigs != null ? !fuelConfigs.equals(that.fuelConfigs) : that.fuelConfigs != null) return false;
        if (configCacheMinutes != null ? !configCacheMinutes.equals(that.configCacheMinutes) : that.configCacheMinutes != null)
            return false;
        if (sitesCacheMinutes != null ? !sitesCacheMinutes.equals(that.sitesCacheMinutes) : that.sitesCacheMinutes != null)
            return false;
        if (priceCacheMinutes != null ? !priceCacheMinutes.equals(that.priceCacheMinutes) : that.priceCacheMinutes != null)
            return false;
        return notModified != null ? notModified.equals(that.notModified) : that.notModified == null;

    }

    @Override
    public int hashCode() {
        int result = localDate != null ? localDate.hashCode() : 0;
        result = 31 * result + (cities != null ? cities.hashCode() : 0);
        result = 31 * result + (fuelConfigs != null ? fuelConfigs.hashCode() : 0);
        result = 31 * result + (configCacheMinutes != null ? configCacheMinutes.hashCode() : 0);
        result = 31 * result + (sitesCacheMinutes != null ? sitesCacheMinutes.hashCode() : 0);
        result = 31 * result + (priceCacheMinutes != null ? priceCacheMinutes.hashCode() : 0);
        result = 31 * result + (notModified != null ? notModified.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "PricingMapConfig{" +
                "localDate=" + localDate +
                ", cities=" + cities +
                ", fuelConfigs=" + fuelConfigs +
                ", configCacheMinutes=" + configCacheMinutes +
                ", sitesCacheMinutes=" + sitesCacheMinutes +
                ", priceCacheMinutes=" + priceCacheMinutes +
                ", notModified=" + notModified +
                '}';
    }
}
