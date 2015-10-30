package com.ctm.web.homecontents.services;

import com.ctm.web.homecontents.model.HomeRequest;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.RequestService;
import com.ctm.web.homecontents.utils.HomeRequestParser;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.web.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by voba on 18/06/2015.
 */
public class HomeService {
    private static final Logger LOGGER = LoggerFactory.getLogger(HomeService.class);
    private boolean valid = false;
    private String vertical = Vertical.VerticalType.HOME.getCode();

    public String validate(HttpServletRequest request, Data data) {
        RequestService fromFormService = new RequestService(request, vertical, data);

        HomeRequest homeRequest = HomeRequestParser.parseRequest(data, vertical);
        List<SchemaValidationError> errors = validate(homeRequest);
        if(!valid) {
            return outputErrors(fromFormService, errors);
        }
        return "";
    }

    private List<SchemaValidationError> validate(HomeRequest homeRequest) {
        List<SchemaValidationError> errors = FormValidation.validate(homeRequest, "");
        valid = errors.isEmpty();
        return errors;
    }

    private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
        String response;
        FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "HomeService.java:validate");
        response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
        return response;
    }

    public boolean isValid() {
        return valid;
    }

}
