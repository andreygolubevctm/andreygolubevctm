package com.ctm.web.validation;

import com.ctm.services.FatalErrorService;
import com.ctm.services.life.LifeService;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class FormValidation {

	private static Logger logger = Logger.getLogger(LifeService.class.getName());

	public static <T> List<SchemaValidationError> validate(T request , String vertical) {
		Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
		List<SchemaValidationError> validationErrors = new ArrayList<SchemaValidationError>();

		final Set<ConstraintViolation<T>> violations = validator.validate(request);
		for(ConstraintViolation<T> violation : violations) {
			SchemaValidationError error = new SchemaValidationError();
			error.setElementXpath(vertical + "/" + violation.getPropertyPath().toString().replace(".", "/"));
			error.setMessage(violation.getMessage() + " value= '" + violation.getInvalidValue() + "'");
			validationErrors.add(error);
		}

		return validationErrors;
	}


	public static JSONObject outputToJson(String transactionId, List<SchemaValidationError> errors) {
		JSONObject reponse = new JSONObject();
		JSONObject error = new JSONObject();
		try {
			reponse.put("error" , error);
			error.put("type", "validation");
			error.put("message", "It looks like some fields are incomplete please check your details and try again");
			error.put("transactionId", transactionId);

			JSONObject errorDetails = new JSONObject();
			error.put("errorDetails", errorDetails);

			JSONArray validationErrors = new JSONArray();
			for(SchemaValidationError validationError : errors) {
				validationErrors.put(validationError.toJsonObject());
			}
			errorDetails.put("validationErrors", validationErrors );
		} catch (JSONException e) {
			logger.error(e);
		}
		return reponse;
	}

	public static JSONObject outputToJson(Long transactionId, List<SchemaValidationError> errors) {
		return outputToJson(String.valueOf(transactionId), errors);
	}

	public static void logErrors(String sessionId, String transactionId,
								 int styleCodeId, List<SchemaValidationError> errors , String page) {
		FatalErrorService fatalErrorService  = new FatalErrorService(sessionId);
		for(SchemaValidationError error: errors){
			String description = "Message: " + error.getMessage() + " xpath:" + error.getElementXpath();
			logger.error("validation errors " + description);
			fatalErrorService.logFatalError(styleCodeId, page, false, "validationError ", description, transactionId);
		}
	}

	public static void logErrors(String sessionId, Long transactionId,
								 int styleCodeId, List<SchemaValidationError> errors , String page) {
		logErrors(sessionId, String.valueOf(transactionId),styleCodeId, errors , page);
	}

}
