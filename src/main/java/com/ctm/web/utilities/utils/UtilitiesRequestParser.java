package com.ctm.web.utilities.utils;

import com.ctm.model.request.utilities.Application;
import com.ctm.model.request.utilities.Details;
import com.ctm.model.request.utilities.UtilitiesRequest;
import com.disc_au.web.go.Data;

/**
 * Created by voba on 15/06/2015.
 */
public class UtilitiesRequestParser {
    public static UtilitiesRequest parseRequest(Data data, String vertical) {
        UtilitiesRequest request = new UtilitiesRequest();

        Application application = new Application();
        Details details = new Details();
        details.firstName = data.getString(vertical.toLowerCase() + "/application/details/firstName");
        details.lastName = data.getString(vertical.toLowerCase() + "/application/details/lastName");
        application.details = details;

        Details resultsDisplayed = new Details();
        resultsDisplayed.firstName = data.getString(vertical.toLowerCase() + "/resultsDisplayed/firstName");

        request.application = application;
        request.resultsDisplayed = resultsDisplayed;

        return request;
    }
}
