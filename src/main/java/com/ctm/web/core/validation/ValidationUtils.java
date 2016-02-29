package com.ctm.web.core.validation;

import java.util.List;


public class ValidationUtils {

    public static String getValueAndAddToErrorsIfEmpty(String value, String xpath, List<SchemaValidationError> validationErrors) {
        boolean hasValue = false;
        if(value != null){
            value =  value.trim();
            hasValue = !value.isEmpty();
        }
        if(!hasValue) {
            createRequiredError(xpath, validationErrors);
        }
        return value;
    }

    private static void createRequiredError(String xpath, List<SchemaValidationError> validationErrors) {
        SchemaValidationError error = new SchemaValidationError();
        error.setElementXpath(xpath);
        error.setMessage(SchemaValidationError.REQUIRED);
        validationErrors.add(error);
    }

    public static void getValueAndAddToErrorsIfNull(Object value, String xpath, List<SchemaValidationError> validationErrors) {
        if(value == null) {
            createRequiredError(xpath, validationErrors);
        }
    }

    public static String getValueAndAddToErrorsIfEmptyNumeric(String number, String xpath, List<SchemaValidationError> validationErrors) {
        boolean hasValue = false;
        if(number != null){
            number =  number.replaceAll( "[^\\d]", "" );
            hasValue = !number.isEmpty();
        }
        if(!hasValue) {
            createRequiredError(xpath, validationErrors);
        }
        return number;
    }
}
