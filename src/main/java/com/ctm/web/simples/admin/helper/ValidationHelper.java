package com.ctm.web.simples.admin.helper;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;

import java.util.List;

public class ValidationHelper {

    private ValidationHelper() { /* Private constructor to prevent utility class instantiation. Intentionally Empty. */}

    public static void validate(Object request) throws CrudValidationException {
        List<SchemaValidationError> validationErrors = FormValidation.validate(request, "");
        if (!validationErrors.isEmpty()) {
            throw new CrudValidationException(validationErrors);
        }
    }
}
