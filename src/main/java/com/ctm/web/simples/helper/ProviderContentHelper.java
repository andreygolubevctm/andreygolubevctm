package com.ctm.web.simples.helper;

import com.ctm.exceptions.CrudValidationException;
import com.ctm.model.ProviderContent;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;

import java.util.Date;
import java.util.List;

public class ProviderContentHelper {

	public void validate(Object object) throws CrudValidationException {
		List<SchemaValidationError> validationErrors = FormValidation.validate(object, "");
		if(!validationErrors.isEmpty()) {
			throw new CrudValidationException(validationErrors);
		}
	}

	public ProviderContent createProviderContentObject(int providerContentId, int providerContentTypeId, String providerContentText, Date effectiveStart, Date effectiveEnd, int providerId, int verticalId) {
		ProviderContent providerContent = new ProviderContent();
		providerContent.setProviderContentId(providerContentId);
		providerContent.setProviderContentTypeId(providerContentTypeId);
		providerContent.setProviderContentText(providerContentText);
		providerContent.setEffectiveStart(effectiveStart);
		providerContent.setEffectiveEnd(effectiveEnd);
		providerContent.setProviderId(providerId);
		providerContent.setVerticalId(verticalId);
		return providerContent;
	}

}
