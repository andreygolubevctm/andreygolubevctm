package com.ctm.web.simples.helper;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.model.SpecialOptIn;

import java.util.List;

public class SpecialOptInHelper {
    public List<SchemaValidationError> validateSpecialOptInRowData(SpecialOptIn specialOptIn) throws DaoException {
        List<SchemaValidationError> validationErrors = FormValidation.validate(specialOptIn, "");
        return validationErrors;
    }

    public SpecialOptIn createSpecialOptInObject(int specialOptInId, String content, int verticalId, String vertical, int styleCodeId,
                                       String styleCodeName, String effectiveStart, String effectiveEnd) throws DaoException {

        SpecialOptIn specialOptIn = new SpecialOptIn();
        specialOptIn.setSpecialOptInId(specialOptInId);
        specialOptIn.setContent(content);
        specialOptIn.setVerticalId(verticalId);
        specialOptIn.setVertical(vertical);
        specialOptIn.setStyleCodeId(styleCodeId);
        specialOptIn.setStyleCode(styleCodeName);
        specialOptIn.setEffectiveStart(effectiveStart);
        specialOptIn.setEffectiveEnd(effectiveEnd);

        return specialOptIn;
    }
}
