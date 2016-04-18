package com.ctm.web.health.services;

import com.ctm.web.core.model.resultsData.BaseResultObj;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.services.*;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Simples;
import com.ctm.web.health.model.request.BaseHealthRequest;
import com.ctm.web.health.utils.HealthRequestParser;
import com.ctm.web.health.validation.HealthQuoteValidation;
import com.ctm.web.health.validation.HealthTokenValidationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * TODO: move code away from health_quote_results.jsp and turn this into a router
 * This class should not be used as a singleton class due to the fact that concurrent
 * thread could alter the validToken value or the TokenValidation token value
 */
public class HealthQuoteEndpointService extends CTMEndpointService {


    private static final Logger LOGGER = LoggerFactory.getLogger(HealthQuoteEndpointService.class.getName());

    private final SessionDataServiceBean sessionDataService;
    private final RequestService requestService;
    private boolean validRequest = true;
    private List<SchemaValidationError> validationErrors;

    /**
     * used by health_quote_results.jsp
     * When  health_quote_results.jsp is deleted remove this constructor
     */
    @SuppressWarnings("unused")
    @Deprecated
    public HealthQuoteEndpointService() {
        sessionDataService = new SessionDataServiceBean();
        this.requestService = new RequestService(Vertical.VerticalType.HEALTH );
    }

    public HealthQuoteEndpointService(HealthTokenValidationService tokenService, RequestService requestService) {
        sessionDataService = new SessionDataServiceBean();
        this.tokenService = tokenService;
        this.requestService = requestService;
    }

    public void init(HttpServletRequest httpRequest, PageSettings pageSettings, HealthRequest healthRequest, boolean isCallCentre) {
        requestService.setRequest(httpRequest);
        BaseHealthRequest request = HealthRequestParser.getHealthRequestToken(requestService, isCallCentre);
        if (tokenService == null) {
            this.tokenService = new HealthTokenValidationService(new SettingsService(httpRequest) , sessionDataService, pageSettings.getVertical());
        }
        super.validateToken(httpRequest, tokenService, request);

        HealthQuoteValidation healthQuoteValidation = new HealthQuoteValidation();
        validationErrors = healthQuoteValidation.validate(healthRequest, isCallCentre);
        if(!validationErrors.isEmpty()){
            validRequest = false;
        }
    }

    @Deprecated
    public void init(HttpServletRequest httpRequest, PageSettings pageSettings, Data data) throws JspException {
        HealthRequest healthRequest = new HealthRequest();
        HealthQuote health = new HealthQuote();
        Simples simples = new Simples();
        simples.setContactType(data.getString(HealthQuoteValidation.CONTACT_TYPE_XPATH));
        health.setSimples(simples);
        healthRequest.setHealth(health);
        boolean isCallCentre = SessionUtils.isCallCentre(httpRequest.getSession());
        init( httpRequest,  pageSettings, healthRequest, isCallCentre);
    }

    public ResultsWrapper createResultsWrapper(HttpServletRequest httpRequest, Long transactionId, BaseResultObj results) {
        return tokenService.createResultsWrapper(transactionId, httpRequest, results);
    }

    public ResultsWrapper createResultsWrapper(HttpServletRequest httpRequest, Long transactionId, com.ctm.web.core.model.resultsData.Error error) {
        return tokenService.createResultsWrapper(transactionId, httpRequest, error);
    }


    public boolean isValidRequest() {
        return validRequest;
    }

    public List<SchemaValidationError> getValidationErrors() {
        return validationErrors;
    }

    @Deprecated
    public String createErrorResponseInvalidRequest(Long transactionId) {
        LOGGER.error("Validation errors {}" , kv("validationErrors" , validationErrors) );
        return FormValidation.outputToJson(transactionId, validationErrors).toString();
    }
}
