package com.ctm.web.core.utils.roadside;

import com.ctm.web.roadside.model.request.RoadsideRequest;
import com.ctm.web.core.web.go.Data;

public class RoadsideRequestParser {

    public static RoadsideRequest parseRequest(Data data, String vertical) {
        RoadsideRequest request = new RoadsideRequest();
        request.year = data.getInteger(vertical.toLowerCase() + "/vehicle/year");
        return request;
    }
}
