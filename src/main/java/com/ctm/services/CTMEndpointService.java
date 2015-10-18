package com.ctm.services;

import com.ctm.model.PageRequest;
import com.ctm.web.validation.TokenValidation;

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

    public boolean isValidToken() {
        return validToken;
    }

}
