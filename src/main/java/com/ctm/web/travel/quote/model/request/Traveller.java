package com.ctm.web.travel.quote.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class Traveller {

    private TravellerType travellerType;

    @JsonSerialize
    private Integer age;

    public TravellerType getTravellerType() {
        return travellerType;
    }

    public void setTravellerType(TravellerType travellerType) {
        this.travellerType = travellerType;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }
}
