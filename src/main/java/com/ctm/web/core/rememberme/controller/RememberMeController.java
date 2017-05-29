package com.ctm.web.core.rememberme.controller;

import com.ctm.web.core.rememberme.services.RememberMeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Optional;


@SuppressWarnings("unused")
@RestController
@RequestMapping("/rest/rememberme")
public class RememberMeController {
    private static final Logger LOGGER = LoggerFactory.getLogger(RememberMeController.class);

    private static final String QUOTE_GET_JSON = "/quote/get.json";
    private static final String QUOTE_DELETE_COOKIE_JSON = "/quote/deleteCookie.json";
    private static final String QUOTE_TYPE = "quoteType";
    private static final String QUERY_VALUE = "userAnswer";

    private final RememberMeService rememberMeService;

    @Autowired
    public RememberMeController(final RememberMeService rememberMeService) {
        this.rememberMeService = rememberMeService;
    }

    @RequestMapping(value = QUOTE_GET_JSON, method = RequestMethod.GET)
    public String validateAnswer(@RequestParam(QUOTE_TYPE) final String vertical,
                                 @RequestParam(QUERY_VALUE) final String userAnswer,
                                 HttpServletRequest request,
                                 final HttpServletResponse response) throws IOException, GeneralSecurityException {
        boolean isValidAnswer;
        Integer accessTokenCounter;
        Optional<String> transactionId;
        try {
            if (RememberMeService.isRememberMeEnabled(request, vertical)) {
                transactionId = rememberMeService.getTransactionIdFromCookie(vertical, request);
                isValidAnswer = rememberMeService.validateAnswerAndLoadData(vertical, userAnswer, request);
                rememberMeService.updateAttemptsCounter(request, response, vertical);
                if(isValidAnswer) {
                    rememberMeService.deleteCookie(vertical, response);
                    rememberMeService.removeAttemptsSessionAttribute(request, vertical);
                    return transactionId.orElse(null);
                }
            } else {
                return null;
            }
        } catch (Exception ex) {
            LOGGER.error("Error validating the personal question", ex);
            return null;
        }
        return null;
    }


    @RequestMapping(value = QUOTE_DELETE_COOKIE_JSON, method = RequestMethod.POST)
    public boolean deleteCookie(@RequestParam(QUOTE_TYPE) final String vertical,
                                final HttpServletRequest request,
                                final HttpServletResponse response) throws IOException, GeneralSecurityException {
        Boolean isCookieRemoved = rememberMeService.deleteCookie(vertical, response);
        Boolean isAttemptsAttributeRemoved = rememberMeService.removeAttemptsSessionAttribute(request, vertical);
        return (isCookieRemoved && isAttemptsAttributeRemoved);
    }
}