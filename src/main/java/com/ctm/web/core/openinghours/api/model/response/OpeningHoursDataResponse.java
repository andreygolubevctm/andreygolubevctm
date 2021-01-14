package com.ctm.web.core.openinghours.api.model.response;

import com.ctm.web.core.openinghours.model.OpeningHours;

import java.util.List;

public class OpeningHoursDataResponse {

    private final List<OpeningHours> openingHours;

    public OpeningHoursDataResponse(List<OpeningHours> openingHours) {
        this.openingHours = openingHours;
    }

    public List<OpeningHours> getOpeningHours() {
        return openingHours;
    }
}
