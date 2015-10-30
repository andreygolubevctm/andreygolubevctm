package com.ctm.services.roadside;

import com.ctm.web.roadside.model.request.RoadsideRequest;
import com.ctm.services.RequestService;
import com.ctm.web.core.utils.roadside.RoadsideRequestParser;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.core.web.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by voba on 12/05/2015.
 */
public class RoadsideService {
    private boolean valid = false;
    private String vertical = "ROADSIDE";

    public String validate(HttpServletRequest request, Data data) {
        RequestService fromFormService = new RequestService(request, vertical, data);

        RoadsideRequest roadsideRequest = RoadsideRequestParser.parseRequest(data, vertical);
        List<SchemaValidationError> errors = validate(roadsideRequest);
        if(!valid) {
            return outputErrors(fromFormService, errors);
        }
        return "";
    }

    private List<SchemaValidationError> validate(RoadsideRequest roadsideRequest) {
        List<SchemaValidationError> errors = FormValidation.validate(roadsideRequest, "");
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
