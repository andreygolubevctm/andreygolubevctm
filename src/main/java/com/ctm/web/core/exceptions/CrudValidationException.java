package com.ctm.web.core.exceptions;

import com.ctm.web.core.validation.SchemaValidationError;

import java.util.List;

/**
 * Created by lbuchanan on 23/04/2015.
 */
public class CrudValidationException extends Exception {
    private final List<SchemaValidationError> validationErrors;

    public CrudValidationException(List<SchemaValidationError> validationErrors) {
        this.validationErrors = validationErrors;
    }

    public List<SchemaValidationError> getValidationErrors() {
        return validationErrors;
    }
}
