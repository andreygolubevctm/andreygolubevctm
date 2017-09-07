package com.ctm.web.fuel.quote.model.citysites;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.util.List;

public class CitySites {
    @JsonDeserialize
    @JsonProperty("Cities")
    private List<City> cities;

    @JsonDeserialize
    @JsonProperty("N")
    private Boolean notModified;

    private CitySites() {}

    public List<City> getCities() {
        return cities;
    }

    public Boolean getNotModified() {
        return notModified;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        CitySites citySites = (CitySites) o;

        if (cities != null ? !cities.equals(citySites.cities) : citySites.cities != null) return false;
        return notModified != null ? notModified.equals(citySites.notModified) : citySites.notModified == null;

    }

    @Override
    public int hashCode() {
        int result = cities != null ? cities.hashCode() : 0;
        result = 31 * result + (notModified != null ? notModified.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "CitySites{" +
                "cities=" + cities +
                ", notModified=" + notModified +
                '}';
    }
}
