package com.ctm.web.health.helper;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.model.ProviderContent;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;

import java.util.Date;
import java.util.List;

public class ProviderContentHelper {

	public void validate(Object object) throws CrudValidationException {
		List<SchemaValidationError> validationErrors = FormValidation.validate(object, "");
		if(!validationErrors.isEmpty()) {
			throw new CrudValidationException(validationErrors);
		}
	}

	public ProviderContent createProviderContentObject(int providerContentId, int providerContentTypeId, String providerContentText, Date effectiveStart, Date effectiveEnd, int providerId, int verticalId, int styleCodeId, String styleCodeName) {
		ProviderContent providerContent = new ProviderContent();
		providerContent.setProviderContentId(providerContentId);
		providerContent.setProviderContentTypeId(providerContentTypeId);
		providerContent.setProviderContentText(providerContentText);
		providerContent.setEffectiveStart(effectiveStart);
		providerContent.setEffectiveEnd(effectiveEnd);
		providerContent.setProviderId(providerId);
		providerContent.setVerticalId(verticalId);
		providerContent.setStyleCodeId(styleCodeId);
		providerContent.setStyleCode(styleCodeName);
		return providerContent;
	}

}
