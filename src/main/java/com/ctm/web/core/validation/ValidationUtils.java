package com.ctm.web.core.validation;

import org.apache.commons.lang3.StringUtils;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;

import java.util.ArrayList;
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
                FieldError fieldError = ((FieldError) objectError);
                xpath = fieldError.getField().replace(".", "/");
            }
            if(objectError.getCode().equals("NotNull") || isEmptyStringError(objectError)) {
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

    private static boolean isEmptyStringError(ObjectError objectError){
        boolean isEmptyStringError = false;
        if(objectError instanceof FieldError) {
            FieldError fieldError = ((FieldError) objectError);
            Object rejectedValue = fieldError.getRejectedValue();
            if(rejectedValue instanceof String) {
                return objectError.getCode().equals("Size") && StringUtils.isEmpty((String) rejectedValue);
            }
        }
        return isEmptyStringError;
    }
}
