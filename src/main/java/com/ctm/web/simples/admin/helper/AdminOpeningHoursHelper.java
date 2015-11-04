package com.ctm.web.simples.admin.helper;

import com.ctm.web.core.model.OpeningHours;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.services.OpeningHoursAdminService;

import java.util.List;

public class AdminOpeningHoursHelper {

    public List<SchemaValidationError> validateHoursRowData(OpeningHours openingHours) {
        List<SchemaValidationError> validationErrors = FormValidation.validate(openingHours, "");
        if ((openingHours.getHoursType() != null && openingHours.getHoursType().trim().equalsIgnoreCase("s"))
                && (openingHours.getDate() == null || openingHours.getDate().trim().equals(""))) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElementXpath(OpeningHoursAdminService.dateField);
            error.setMessage("Date can not be empty when Hours Type is Special 'S'");
            validationErrors.add(error);
        } else if ((openingHours.getHoursType() != null && openingHours.getHoursType().trim().equalsIgnoreCase("n"))
                && (openingHours.getDaySequence() == null || openingHours.getDaySequence().trim().equals(""))) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElementXpath(OpeningHoursAdminService.sequenceField);
            error.setMessage("Sequence of the Day can not be empty when Hours Type is Normal 'N'");
            validationErrors.add(error);
        }
        return validationErrors;

    }
}
