package com.ctm.model.request.roadside;

import com.ctm.web.validation.Year;

public class RoadsideRequest {

    @Year(message = "Year cannot be in the future")
    public Integer year;
}
