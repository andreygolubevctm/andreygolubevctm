package com.ctm.helper.simples;

import com.ctm.exceptions.CrudValidationException;
import com.ctm.model.FundWarningMessage;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;

import java.util.Date;
import java.util.List;

public class FundWarningHelper {

	public void validate(Object object) throws CrudValidationException {
		List<SchemaValidationError> validationErrors = FormValidation.validate(object, "");
		if(!validationErrors.isEmpty()) {
			throw new CrudValidationException(validationErrors);
		}
	}

	public FundWarningMessage createFundWarningMessageObject(int messageId, String messageContent, Date effectiveStart, Date effectiveEnd, int providerId, int verticalId) {
		FundWarningMessage fundWarningMessage = new FundWarningMessage();
		fundWarningMessage.setMessageId(messageId);
		fundWarningMessage.setMessageContent(messageContent);
		fundWarningMessage.setEffectiveStart(effectiveStart);
		fundWarningMessage.setEffectiveEnd(effectiveEnd);
		fundWarningMessage.setProviderId(providerId);
		fundWarningMessage.setVerticalId(verticalId);
		return fundWarningMessage;
	}

}
