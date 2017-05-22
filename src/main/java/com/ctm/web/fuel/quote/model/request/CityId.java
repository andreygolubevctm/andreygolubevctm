package com.ctm.web.fuel.quote.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class CityId {
    @JsonSerialize
    @JsonProperty("CityId")
    private Long cityId;

    private CityId() {}

    public CityId(Long cityId) {
        this.cityId = cityId;
    }
}
