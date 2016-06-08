package com.ctm.web.core.validation;

import org.apache.commons.lang3.StringUtils;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import  com.ctm.web.core.validation.SchemaValidationError;

import java.util.ArrayList;
import java.util.List;


public class ValidationUtils {



    private static void createRequiredError(String xpath, List<com.ctm.web.core.validation.SchemaValidationError> validationErrors) {
        com.ctm.web.core.validation.SchemaValidationError error = new com.ctm.web.core.validation.SchemaValidationError();
        error.setElementXpath(xpath);
        error.setMessage(com.ctm.web.core.validation.SchemaValidationError.REQUIRED);
        validationErrors.add(error);
    }

    public static List<SchemaValidationError> handleSpringValidationErrors(BindException e) {
        List<SchemaValidationError> validationErrors = new ArrayList<>();
        for(ObjectError objectError : e.getAllErrors()) {
            String xpath = objectError.getObjectName();
            if(objectError instanceof FieldError) {
                xpath = ((FieldError) objectError).getField().replace(".", "/");
            }
            if(objectError.getCode().equals("NotNull")) {
                ValidationUtils.createRequiredError( xpath, validationErrors);
            } else {
                SchemaValidationError error = new SchemaValidationError();
                error.setMessage(objectError.getCode());
                error.setElementXpath(xpath);
                validationErrors.add(error);
            }
        }
        return validationErrors;
    }
}
