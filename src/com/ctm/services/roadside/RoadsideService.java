package com.ctm.services.roadside;

import com.ctm.model.request.roadside.RoadsideRequest;
import com.ctm.services.RequestService;
import com.ctm.utils.roadside.RoadsideRequestParser;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by voba on 12/05/2015.
 */
public class RoadsideService {
    private boolean valid = false;
    private String vertical = "ROADSIDE";

    public String validate(HttpServletRequest request) {
        RequestService fromFormService = new RequestService(request, vertical);
        Data data = fromFormService.getRequestData();
        RoadsideRequest roadsideRequest = RoadsideRequestParser.parseRequest(data, vertical);
        List<SchemaValidationError> errors = validate(roadsideRequest, vertical);
        if(!valid) {
            return outputErrors(fromFormService, errors);
        }
        return "";
    }

    public List<SchemaValidationError> validate(RoadsideRequest lifeRequest, String vertical) {
        List<SchemaValidationError> errors = FormValidation.validate(lifeRequest, vertical);
        valid = errors.isEmpty();
        return errors;
    }

    private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
        String response;
        FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "RoadsideService.java:validate");
        response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
        return response;
    }

    public boolean isValid() {
        return valid;
    }
}
