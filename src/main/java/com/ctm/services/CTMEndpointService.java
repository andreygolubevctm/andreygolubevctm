package com.ctm.services;

import com.ctm.model.PageRequest;
import com.ctm.web.validation.TokenValidation;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;


public class CTMEndpointService {

    protected TokenValidation tokenService;
    protected HttpServletRequest httpRequest;
    protected boolean validToken;

    public void validateToken(HttpServletRequest httpRequest, TokenValidation tokenService, PageRequest request) {
        this.httpRequest = httpRequest;
        this.tokenService = tokenService;
        validToken = tokenService.validateToken(request);
    }

    public String createResponse(Long transactionId, String baseJsonResponse) {
        return tokenService.createResponse(transactionId, baseJsonResponse, httpRequest);
    }

    public String createErrorResponse(Long transactionId, String errorMessage, String type) {
        return tokenService.createErrorResponse(transactionId, errorMessage, httpRequest, type);
    }

    public String createErrorResponseInvalidToken(Long transactionId) {
        return tokenService.createErrorResponse(transactionId, "Token has expired or is invalid", httpRequest, "InvalidVerificationToken");
    }

    public JSONObject appendValuesToResponse(JSONObject jSONObject , Long transactionId) throws JSONException {
        return tokenService.createResponse(transactionId, httpRequest, jSONObject);
    }

    public boolean isValidToken() {
        return validToken;
    }

}
