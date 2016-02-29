package com.ctm.web.core.validation.model;

import com.ctm.web.core.model.resultsData.ErrorDetails;
import com.ctm.web.core.validation.SchemaValidationError;

import java.util.List;

public class ValidationErrorDetails extends ErrorDetails {

    private List<SchemaValidationError> validationErrors;

    public ValidationErrorDetails(String errorType) {
        super(errorType);
    }

    public List<SchemaValidationError> getValidationErrors() {
        return validationErrors;
    }

    public void setValidationErrors(List<SchemaValidationError> validationErrors) {
        this.validationErrors = validationErrors;
    }
}
