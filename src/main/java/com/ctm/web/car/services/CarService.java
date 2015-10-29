package com.ctm.web.car.services;

import com.ctm.web.car.model.request.CarRequest;
import com.ctm.model.settings.Vertical;
import com.ctm.services.RequestService;
import com.ctm.web.car.utils.CarRequestParser;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by voba on 6/07/2015.
 */
public class CarService {
    private boolean valid = false;
    private String vertical = Vertical.VerticalType.CAR.getCode();

    public String validate(HttpServletRequest request, Data data) {
        RequestService fromFormService = new RequestService(request, vertical, data);

        CarRequest carRequest = CarRequestParser.parseRequest(data);
        List<SchemaValidationError> errors = validate(carRequest);
        if(!valid) {
            return outputErrors(fromFormService, errors);
        }
        return "";
    }


    private List<SchemaValidationError> validate(CarRequest carRequest) {
        // Passing "quote" instead of "CAR" to meet xpath
        List<SchemaValidationError> errors = FormValidation.validate(carRequest, "quote");
        valid = errors.isEmpty();
        return errors;
    }

    private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
        String response;
        FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "CarService.java:validate");
        response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
        return response;
    }

    public boolean isValid() {
        return valid;
    }
}
