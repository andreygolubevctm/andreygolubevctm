package com.ctm.web.core.validation;

import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.request.TokenRequest;
import com.ctm.web.core.model.resultsData.BaseResultObj;
import com.ctm.web.core.model.resultsData.Error;
import com.ctm.web.core.model.resultsData.ErrorDetails;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.security.token.JwtTokenCreator;
import com.ctm.web.core.security.token.JwtTokenValidator;
import com.ctm.web.core.security.token.config.TokenConfigFactory;
import com.ctm.web.core.security.token.config.TokenCreatorConfig;
import com.ctm.web.core.security.token.exception.InvalidTokenException;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.ResponseUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public abstract class TokenValidation<T extends TokenRequest> {


    private static final Logger LOGGER = LoggerFactory.getLogger(TokenValidation.class.getName());

    private final JwtTokenValidator tokenValidation;
    private final SessionDataServiceBean sessionDataService;
    private final SettingsService settingsService;
    private Vertical vertical;

    private boolean validToken;

    public TokenValidation(SettingsService settingsService, SessionDataServiceBean sessionDataService, Vertical vertical) {
        this.sessionDataService = sessionDataService;
        this.settingsService = settingsService;
        tokenValidation = new JwtTokenValidator(TokenConfigFactory.getJwtSecretKey(vertical));
        setVertical(vertical);
        this.vertical = vertical;
    }


    /**
     * Checks if the token is valid right step, not expired and valid transaction id
     *
     * @param request contains jwt token and transactionId to validate against
     * @return boolean to state if token is valid
     */
    public boolean validateToken(T request) {
        if (TokenConfigFactory.getEnabled(vertical)) {
            validToken = false;
            try {
                tokenValidation.validateToken(request, getValidTouchTypes());
                validToken = true;
            } catch (InvalidTokenException exception) {
                LOGGER.warn("Token is invalid. {}", request , exception);
            }
        } else {
            validToken = true;
        }
        return validToken;
    }

    /**
     * Return list of touches that validateToken will count as valid
     */
    protected abstract List<Touch.TouchType> getValidTouchTypes();

    /**
     * Return what TouchType created tokens will be
     */
    protected abstract Touch.TouchType getCurrentTouch();

    public void setNewToken(JSONObject response, Long transactionId, HttpServletRequest request) {
        TokenCreatorConfig config = TokenConfigFactory.getInstance(vertical, getCurrentTouch(), request);
        String token = TokenValidation.createToken(transactionId, sessionDataService, settingsService, config, request.getServletPath(), request);
        try {
            ResponseUtils.setToken(response, token);
            response.put("timeout", sessionDataService.getClientSessionTimeout(request));
        } catch (JSONException e) {
            LOGGER.error("Failed to set new Token. {}", kv("transactionId", transactionId), e);
        }
    }

    public static String createToken(Long transactionId, SessionDataServiceBean sessionDataService, SettingsService settingsService, TokenCreatorConfig config, String servletPath, HttpServletRequest request) {
        long timeoutSec = sessionDataService.getClientSessionTimeoutSeconds(request);
        if (timeoutSec == -1) {
            timeoutSec = sessionDataService.getClientDefaultExpiryTimeoutSeconds(request) + 10;
        }
        JwtTokenCreator creator = new JwtTokenCreator(settingsService, config);
        return creator.createToken(servletPath, transactionId, timeoutSec);
    }

    public String createResponse(Long transactionId, String baseJsonResponse, HttpServletRequest request) {
        String output = "";
        try {
            JSONObject response;
            if (baseJsonResponse != null && !baseJsonResponse.isEmpty()) {
                response = new JSONObject(baseJsonResponse);
            } else {
                response = new JSONObject();
            }
            if (TokenConfigFactory.getEnabled(vertical, request)) {
                if (validToken) {
                    response = createValidTokenResponse(transactionId, request, response);
                } else {
                    response = createInvalidTokenResponse(transactionId, response);
                }
            }
            long timeout = sessionDataService.getClientSessionTimeout(request);
            response.put("timeout", timeout);
            response.put("transactionId", transactionId);
            output = response.toString();
        } catch (JSONException e) {
            LOGGER.error("Failed to create JSON response. {}", kv("baseJsonResponse", baseJsonResponse), e);
        }
        return output;
    }

    public ResultsWrapper createResultsWrapper(Long transactionId, HttpServletRequest request, BaseResultObj results) {
        if (TokenConfigFactory.getEnabled(vertical, request)) {
            if (validToken) {
                TokenCreatorConfig config = TokenConfigFactory.getInstance(vertical, getCurrentTouch(), request);
                String token = TokenValidation.createToken(transactionId, sessionDataService, settingsService, config, request.getServletPath(), request);
                return new ResultsWrapper(results, token);
            } else {
                String message = "token expired";
                Error error = new Error(message, message, transactionId, new ErrorDetails(""));
                return new ResultsWrapper(results, error);
            }
        } else {
            return new ResultsWrapper(results);
        }
    }

    public ResultsWrapper createResultsWrapper(Long transactionId, HttpServletRequest request, Error error) {
        if (TokenConfigFactory.getEnabled(vertical, request)) {
            if (validToken) {
                TokenCreatorConfig config = TokenConfigFactory.getInstance(vertical, getCurrentTouch(), request);
                String token = TokenValidation.createToken(transactionId, sessionDataService, settingsService, config, request.getServletPath(), request);
                return new ResultsWrapper( null , token,  error);
            }
        }
        return new ResultsWrapper(null,  error);
    }
    
    public String createErrorResponse(Long transactionId, String errorMessage, HttpServletRequest request, String type) {
        String responseString = "";
        try {
            JSONObject response = new JSONObject();
            JSONObject error = new JSONObject();
            error.put("type", type);
            error.put("message", errorMessage);
            response.put("error", error);
            if (TokenConfigFactory.getEnabled(vertical, request) && isValidToken()) {
                setNewToken(response, transactionId, request);
            }
            responseString = response.toString();
        } catch (JSONException e) {
            LOGGER.warn("Failed to create response. {}", kv("errorMessage", errorMessage), e);
        }
        return responseString;
    }

    public JSONObject createResponse(Long transactionId, HttpServletRequest request, JSONObject response) throws JSONException {
        if (TokenConfigFactory.getEnabled(vertical, request) && isValidToken()) {
            setNewToken(response, transactionId, request);
            response.put("transactionId", transactionId);
        }
        return response;
    }

    private JSONObject createValidTokenResponse(Long transactionId, HttpServletRequest request, JSONObject response) throws JSONException {
        setNewToken(response, transactionId, request);
        return response;
    }

    private JSONObject createInvalidTokenResponse(Long transactionId, JSONObject response) throws JSONException {
        String message = "token expired";
        JSONObject error = new JSONObject();
        error.put("type", message);
        error.put("message", message);
        error.put("transactionId", transactionId);
        JSONObject errorDetails = new JSONObject();
        errorDetails.put("errorType", "");
        error.put("errorDetails", errorDetails);
        response.put("error", error);
        response.put("timeout", -1);
        return response;
    }

    public boolean isValidToken() {
        return validToken;
    }

    public void setVertical(Vertical vertical) {
        this.vertical = vertical;
    }
}
