package com.ctm.web.core.validation;

import org.apache.commons.lang3.StringUtils;

import java.util.List;


public class ValidationUtils {

    public static String getValueAndAddToErrorsIfEmpty(String value, String xpath, List<SchemaValidationError> validationErrors) {
        boolean hasValue = StringUtils.isNotBlank(value);
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
