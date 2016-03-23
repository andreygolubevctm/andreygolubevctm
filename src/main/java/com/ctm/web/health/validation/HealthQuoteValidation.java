package com.ctm.web.health.validation;

import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.core.validation.ValidationUtils;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Simples;

import java.util.ArrayList;
import java.util.List;


public class HealthQuoteValidation {

    public static final String CONTACT_TYPE_XPATH = "health/simples/contactType";

	public List<SchemaValidationError> validate(HealthRequest request, boolean isCallCentre) {
        List<SchemaValidationError> validationErrors = new ArrayList<>();
		if(isCallCentre) {
			validateContactType(request, validationErrors);
		}
		return validationErrors;
	}
	private void validateContactType(HealthRequest request, List<SchemaValidationError> validationErrors) {
        Simples simples = request.getHealth().getSimples();
        if(simples != null) {
            ValidationUtils.getValueAndAddToErrorsIfEmpty(simples.getContactType(), CONTACT_TYPE_XPATH,
                    validationErrors);
        } else {
            ValidationUtils.getValueAndAddToErrorsIfNull(simples, CONTACT_TYPE_XPATH,
                    validationErrors);
        }

	}

}
