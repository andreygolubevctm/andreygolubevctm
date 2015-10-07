package com.ctm.web.validation;

import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import com.ctm.model.settings.Vertical;
import com.ctm.security.token.JwtTokenCreator;
import com.ctm.security.token.JwtTokenValidator;
import com.ctm.security.token.config.TokenConfigFactory;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.security.token.exception.InvalidTokenException;
import com.ctm.services.SessionDataService;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;

public abstract class TokenValidation<T extends TokenRequest> {


    private static final Logger LOGGER = LoggerFactory.getLogger(TokenValidation.class.getName());

    private final JwtTokenValidator tokenValidation;
    private final SessionDataService sessionDataService;
    private Vertical vertical;

    private boolean validToken;

    public TokenValidation(SessionDataService sessionDataService, Vertical vertical) {
        this.sessionDataService = sessionDataService;
        tokenValidation = new JwtTokenValidator(TokenConfigFactory.getJwtSecretKey(vertical));
        setVertical(vertical);
        this.vertical = vertical;
    }




    /**
     * Checks if the token is valid right step, not expired and valid transaction id
     * @param request contains jwt token and transactionId to validate against
     * @return boolean to state if token is valid
     */
    public boolean validateToken(T request) {
        validToken = false;
        try {
            tokenValidation.validateToken(request, getValidTouchTypes());
            validToken = true;
        } catch (InvalidTokenException exception) {
            LOGGER.warn("Token is invalid. ", exception);
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
        long timeout = sessionDataService.getClientSessionTimeoutSeconds(request);
        long timeoutSec = timeout / 1000;
        if(timeout == -1){
            timeoutSec = sessionDataService.getClientDefaultExpiryTimeoutSeconds(request);
        }
        String token = TokenValidation.createToken(request,transactionId, vertical, getCurrentTouch(), timeoutSec);
        try {
            response.put("verificationToken", token);
            response.put("timeout", timeout);
        } catch (JSONException e) {
            LOGGER.error("Failed to set new Token. {}", kv("transactionId" , transactionId),  e);
        }
    }

    public static String createToken(HttpServletRequest request, Long transactionId, Vertical vertical, Touch.TouchType touchType, long timeoutSec) {
        TokenCreatorConfig config = TokenConfigFactory.getInstance(vertical, touchType, request);
        JwtTokenCreator creator = new JwtTokenCreator(config, TokenConfigFactory.getJwtSecretKey(vertical));
        return creator.createToken(request.getServletPath(), transactionId, timeoutSec);
    }

    public String createResponse(Long transactionId, String baseJsonResponse , HttpServletRequest request) {
        String output = "";
        try {
            JSONObject response;
            if(baseJsonResponse != null && !baseJsonResponse.isEmpty()){
                response = new JSONObject(baseJsonResponse);
            } else {
                response = new JSONObject();
            }
            if(validToken) {
                response = createValidTokenResponse(transactionId, request, response);
            } else {
                response = createInvalidTokenResponse(transactionId, response);
            }
            long timeout = sessionDataService.getClientSessionTimeout(request);
            response.put("timeout", timeout);
            response.put("transactionId", transactionId);
            output = response.toString();
        } catch (JSONException e) {
            LOGGER.error("Failed to create JSON response. {}",kv("baseJsonResponse", baseJsonResponse) , e);
        }
        return output;
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
        response.put("error",error);
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
