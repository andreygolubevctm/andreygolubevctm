package com.ctm.web.core.validation;

import com.ctm.web.core.model.resultsData.Error;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.validation.model.ValidationErrorDetails;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class FormValidation {

    private static final Logger LOGGER = LoggerFactory.getLogger(FormValidation.class);
    public static final String ERROR_TYPE = "validation";
    public static final String MESSAGE = "It looks like some fields are incomplete please check your details and try again";

    public static <T> List<SchemaValidationError> validate(T request , String vertical) {
		return validate(request, vertical, true);
	}

	public static <T> List<SchemaValidationError> validate(T request , String vertical, boolean outputErrorValue) {
		Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
		List<SchemaValidationError> validationErrors = new ArrayList<SchemaValidationError>();
		String errorValue;

		final Set<ConstraintViolation<T>> violations = validator.validate(request);
		for(ConstraintViolation<T> violation : violations) {
			SchemaValidationError error = new SchemaValidationError();
			error.setElementXpath((vertical==null || vertical.trim().equals("")?"":(vertical + "/")) + violation.getPropertyPath().toString().replace(".", "/"));

			// we don't want travel's destination erroneous value to appear. Just alert the user the the destination is invalid.
			if(outputErrorValue) {
				errorValue = violation.getPropertyPath().toString().equals("destination") ? "" : " value= '" + violation.getInvalidValue() + "'";
			} else {
				errorValue = "";
			}

			error.setMessage(violation.getMessage() + errorValue);
			validationErrors.add(error);
		}

		return validationErrors;
	}

	public static JSONObject outputToJson(String transactionId, List<SchemaValidationError> errors) {
		JSONObject reponse = new JSONObject();
		JSONObject error = new JSONObject();
		try {
			reponse.put("error" , error);
			error.put("type", ERROR_TYPE);
			error.put("message", MESSAGE);
			error.put("transactionId", transactionId);

			JSONObject errorDetails = new JSONObject();
			error.put("errorDetails", errorDetails);

			JSONArray validationErrors = new JSONArray();
			for(SchemaValidationError validationError : errors) {
				validationErrors.put(validationError.toJsonObject());
			}
			errorDetails.put("validationErrors", validationErrors );
		} catch (JSONException e) {
			LOGGER.error("Failed to output to json.", e);
		}
		return reponse;
	}

	public static Error outputToObject(Long transactionId, List<SchemaValidationError> errors) {
        String type = ERROR_TYPE;
        String message = MESSAGE;
        ValidationErrorDetails errorDetails = new ValidationErrorDetails(type);
        errorDetails.setValidationErrors(errors);
        Error response = new Error(type, message, transactionId, errorDetails);
        return response;
	}

	public static JSONObject outputToJson(Long transactionId, List<SchemaValidationError> errors) {
		return outputToJson(String.valueOf(transactionId), errors);
	}

	public static void logErrors(String sessionId, String transactionId,
								 int styleCodeId, List<SchemaValidationError> errors , String page) {
		FatalErrorService fatalErrorService  = new FatalErrorService(sessionId);
		for(SchemaValidationError error: errors){
			String description = "Message: " + error.getMessage() + " xpath:" + error.getElementXpath();
			LOGGER.error("validation errors. {}", kv("description", description));
			fatalErrorService.logFatalError(styleCodeId, page, false, "validationError ", description, transactionId);
		}
	}

	public static void logErrors(String sessionId, Long transactionId,
								 int styleCodeId, List<SchemaValidationError> errors , String page) {
		logErrors(sessionId, String.valueOf(transactionId),styleCodeId, errors , page);
	}

}
