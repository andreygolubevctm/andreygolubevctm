package com.ctm.web.fuel.quote.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.List;

public class CitySitesRequest {
    @JsonSerialize
    @JsonProperty("Cities")
    private List<CityId> cities;

    private CitySitesRequest() {}

    public CitySitesRequest(final List<CityId> cities) {
        this.cities = cities;
    }
}
