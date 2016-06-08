package com.ctm.web.core.openinghours.api.model.response;

public class OpeningHoursResponse {

    private final String openingHours;

    public OpeningHoursResponse(String openingHours) {
        this.openingHours = openingHours;
    }

    public String getOpeningHours() {
        return openingHours;
    }
}
