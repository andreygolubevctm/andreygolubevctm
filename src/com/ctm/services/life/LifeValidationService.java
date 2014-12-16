package com.ctm.services.life;

import java.util.ArrayList;
import java.util.List;

import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;


/**
 * This is a short term fix for server side validation. The way validation is handled will be
 * reviewed at a later date. Keep this in mind for future changes.
 * @author lbuchanan
 *
 */
public class LifeValidationService {

	private static final String PRIMARY_OCCUPATION_XPATH = "primary/occupation";
	private static final String PARTNER_OCCUPATION_XPATH = "partner/occupation";

	public List<SchemaValidationError> validateRequestCall(Data data, String vertical) {
		return validateOccupation(data, vertical);
	}
	
	public List<SchemaValidationError> validateQuoteResults(Data data, String vertical) {
		return validateOccupation(data, vertical);
	}


	private List<SchemaValidationError> validateOccupation(Data data, String vertical) {
		List<SchemaValidationError> validationErrors= new ArrayList<SchemaValidationError>();
		validateFortyCharHash(data, validationErrors, vertical + "/" + PRIMARY_OCCUPATION_XPATH);
		validateFortyCharHash(data, validationErrors, vertical + "/" + PARTNER_OCCUPATION_XPATH);
		return validationErrors;
	}

	private void validateFortyCharHash(Data data,
			List<SchemaValidationError> validationErrors, String xpath) {
		Object obj = data.get(xpath);
		String value = "";
		if (obj instanceof String) {
			value = (String) obj;
		}
		
		if(!value.isEmpty()) {
			SchemaValidationError error = new SchemaValidationError();
			error.setElementXpath(xpath);
			if (!value.matches("^([A-Za-z0-9]{40})$"))  {
				error.setMessage(SchemaValidationError.INVALID);
				validationErrors.add(error);
			}
		}
	}

}
