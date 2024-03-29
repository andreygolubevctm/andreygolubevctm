package com.ctm.web.core.rememberme.controller;

import com.ctm.web.core.rememberme.model.RememberMeCookie;
import com.ctm.web.core.rememberme.model.RememberMeDelete;
import com.ctm.web.core.rememberme.services.RememberMeService;
import com.ctm.web.core.rememberme.model.RememberMeValidation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
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
    private static final String ANSWER_VALUE = "userAnswer";
    private static final String REVIEWEDIT_VALUE = "reviewedit";

    private final RememberMeService rememberMeService;

    @Autowired
    public RememberMeController(final RememberMeService rememberMeService) {
        this.rememberMeService = rememberMeService;
    }

    @RequestMapping(value = QUOTE_GET_JSON,
            method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE )
    public RememberMeValidation validateAnswer(@RequestParam(QUOTE_TYPE) final String vertical,
                                               @RequestParam(ANSWER_VALUE) final String userAnswer,
                                               @RequestParam(REVIEWEDIT_VALUE) final String reviewedit, HttpServletRequest request,
                                               final HttpServletResponse response) throws IOException, GeneralSecurityException {
        Boolean isValidAnswer;
        Optional<String> transactionId;
        Boolean isReviewEdit;
        try {
            if (!vertical.isEmpty() && !userAnswer.isEmpty() && RememberMeService.isRememberMeEnabled(request, vertical)) {
                RememberMeCookie rememberMeCookie = rememberMeService.getRememberMeCookie(request, vertical);
                if(rememberMeCookie != null) {
                    transactionId = rememberMeService.getTransactionIdFromCookie(vertical, request);
                    isValidAnswer = rememberMeService.validateAnswerAndLoadData(vertical, userAnswer, request);
                    isReviewEdit = reviewedit.equalsIgnoreCase("Y");
                    rememberMeService.updateAttemptsCounter(request, response, vertical);
                    if (isValidAnswer) {
                        rememberMeService.deleteCookie(vertical, request, response);
                        rememberMeService.removeAttemptsSessionAttribute(request, vertical);
                    }
                    return new RememberMeValidation(isValidAnswer, transactionId.orElse(null), isReviewEdit, rememberMeCookie.getJourneyType());
                }
            }
        } catch (Exception ex) {
            LOGGER.error("Error validating the personal question", ex);
        }
        return new RememberMeValidation(false, null, null, RememberMeService.DEFAULT_JOURNEY_TYPE);
    }


    @RequestMapping(value = QUOTE_DELETE_COOKIE_JSON,
            method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public RememberMeDelete deleteCookie(@RequestParam(QUOTE_TYPE) final String vertical,
                                final HttpServletRequest request,
                                final HttpServletResponse response) throws IOException, GeneralSecurityException {
        RememberMeCookie rememberMeCookie = rememberMeService.getRememberMeCookie(request, vertical);
        if(rememberMeCookie != null) {
            final String journeyType = rememberMeCookie.getJourneyType();
            LOGGER.info("RememberMe request deleteCookie");
            Boolean cookieDeleted = rememberMeService.deleteCookie(vertical, request, response);
            LOGGER.info("RememberMe cookie deleted? {}", cookieDeleted);
            Boolean removeAttemptsSessionAttributeDeleted = cookieDeleted ? rememberMeService.removeAttemptsSessionAttribute(request, vertical) : false;
            LOGGER.info("removeAttemptsSessionAttribute? {}", removeAttemptsSessionAttributeDeleted);
            return new RememberMeDelete(cookieDeleted && removeAttemptsSessionAttributeDeleted, journeyType);
        }
        // If we're here then the cookie either doesn't exist or is invalid so either way it's as good as gone
        return new RememberMeDelete(true, RememberMeService.DEFAULT_JOURNEY_TYPE);
    }
}