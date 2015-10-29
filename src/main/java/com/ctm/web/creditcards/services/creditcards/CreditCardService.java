package com.ctm.web.creditcards.services.creditcards;

import com.ctm.web.creditcards.model.CreditCardRequest;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.services.RequestService;
import com.ctm.web.creditcards.utils.CreditCardRequestParser;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.core.web.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by voba on 26/06/2015.
 */
public class CreditCardService {
    private boolean valid = false;
    private String vertical = Vertical.VerticalType.CREDITCARD.getCode();

    public String validate(HttpServletRequest request, Data data) {
        RequestService fromFormService = new RequestService(request, vertical, data);

        CreditCardRequest creditcardRequest = CreditCardRequestParser.parseRequest(data, vertical);
        List<SchemaValidationError> errors = validate(creditcardRequest);
        if(!valid) {
            return outputErrors(fromFormService, errors);
        }
        return "{}";
    }

    private List<SchemaValidationError> validate(CreditCardRequest creditRequest) {
        List<SchemaValidationError> errors = FormValidation.validate(creditRequest, "");
        valid = errors.isEmpty();
        return errors;
    }

    private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
        String response;
        FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "CreditCardService.java:validate");
        response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
        return response;
    }

    public boolean isValid() {
        return valid;
    }
}
