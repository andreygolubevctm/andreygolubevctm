package com.ctm.web.core.services;

import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.formData.RequestWithQuote;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
public abstract class CommonQuoteService<QUOTE, PAYLOAD, RESPONSE> extends CommonRequestService<PAYLOAD, RESPONSE> {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonQuoteService.class);

    public CommonQuoteService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }

    public boolean validateRequest(RequestWithQuote<QUOTE> data, String verticalCode) {
        // Validate request
        if (data == null) {
            LOGGER.error("Invalid request: data null");
            throw new RouterException("Data quote is missing");
        }
        if(data.getQuote() == null){
            LOGGER.error("Invalid request: data.quote null");
            throw new RouterException("Data quote is missing");
        }
        List<SchemaValidationError> errors = FormValidation.validate(data.getQuote(), verticalCode);
        if(errors.size() > 0){
            LOGGER.error("Invalid request: {}",errors);
            throw new RouterException("Invalid request"); // TODO pass validation errors to client
        }
        return true;
    }

}
