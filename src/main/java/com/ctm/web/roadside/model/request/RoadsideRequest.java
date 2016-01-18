package com.ctm.web.roadside.model.request;

import com.ctm.web.core.validation.Year;

public class RoadsideRequest {

    @Year(message = "Year cannot be in the future")
    public Integer year;
}
