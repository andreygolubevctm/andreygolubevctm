package com.ctm.web.fuel.quote.model.config;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

public class FuelConfig {
    @JsonDeserialize
    @JsonProperty("F")
    private Long id;

    @JsonDeserialize
    @JsonProperty("N")
    private String name;

    @JsonDeserialize
    @JsonProperty("C")
    private Boolean isFuelId;

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Boolean getFuelId() {
        return isFuelId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        FuelConfig fuelConfig = (FuelConfig) o;

        if (id != null ? !id.equals(fuelConfig.id) : fuelConfig.id != null) return false;
        if (name != null ? !name.equals(fuelConfig.name) : fuelConfig.name != null) return false;
        return isFuelId != null ? isFuelId.equals(fuelConfig.isFuelId) : fuelConfig.isFuelId == null;

    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (isFuelId != null ? isFuelId.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "FuelConfig{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", isFuelId=" + isFuelId +
                '}';
    }
}
