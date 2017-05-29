package com.ctm.web.fuel.quote.model.config;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.util.List;

public class CityConfig {
    @JsonDeserialize
    @JsonProperty("C")
    private Long id;

    @JsonDeserialize
    @JsonProperty("N")
    private String name;

    @JsonDeserialize
    @JsonProperty("G")
    private List<Coordinate> coordinates;

    @JsonDeserialize
    @JsonProperty("S")
    private Boolean showPriceBands;

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public List<Coordinate> getCoordinates() {
        return coordinates;
    }

    public Boolean getShowPriceBands() {
        return showPriceBands;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        CityConfig cityConfig = (CityConfig) o;

        if (id != null ? !id.equals(cityConfig.id) : cityConfig.id != null) return false;
        if (name != null ? !name.equals(cityConfig.name) : cityConfig.name != null) return false;
        if (coordinates != null ? !coordinates.equals(cityConfig.coordinates) : cityConfig.coordinates != null) return false;
        return showPriceBands != null ? showPriceBands.equals(cityConfig.showPriceBands) : cityConfig.showPriceBands == null;

    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (coordinates != null ? coordinates.hashCode() : 0);
        result = 31 * result + (showPriceBands != null ? showPriceBands.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "CityConfig{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", coordinates=" + coordinates +
                ", showPriceBands=" + showPriceBands +
                '}';
    }
}
