package com.ctm.web.core.rememberme.controller;

import com.ctm.web.core.model.settings.VerticalSettings;
import com.ctm.web.core.rememberme.services.RememberMeService;
import com.ctm.web.core.services.SettingsService;
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


@SuppressWarnings("unused")
@RestController
@RequestMapping("/rest/rememberme")
public class RememberMeController {
    private static final Logger LOGGER = LoggerFactory.getLogger(RememberMeController.class);

    private static final String QUOTE_GET_JSON = "/quote/get.json";
    private static final String QUOTE_TYPE = "quoteType";
    private static final String QUERY_VALUE = "userAnswer";

    private final RememberMeService rememberMeService;

    @Autowired
    public RememberMeController(final RememberMeService rememberMeService) {
        this.rememberMeService = rememberMeService;
    }

    @RequestMapping(value = QUOTE_GET_JSON, method = RequestMethod.GET)
    public boolean checkQuery(@RequestParam(QUOTE_TYPE) final String vertical,
                              @RequestParam(QUERY_VALUE) final String userAnswer,
                              final HttpServletRequest request,
                              final HttpServletResponse response) throws IOException, GeneralSecurityException {
        boolean isValidAnswer = false;
        Integer accessTokenCounter;

        try {
            if (RememberMeService.isRememberMeEnabled(SettingsService.getPageSettingsForPage(request))) {
                isValidAnswer = rememberMeService.validateAnswerAndLoadData(vertical, userAnswer, request);
                rememberMeService.updateAttemptsCounter(request, response, vertical);
            } else {
                response.sendRedirect(VerticalSettings.getHomePageJsp(vertical));
            }
        } catch (Exception ex) {
            LOGGER.error("Error validating the  personal question", ex);
            response.sendRedirect(VerticalSettings.getHomePageJsp(vertical));
        }
        if (isValidAnswer) {
            rememberMeService.deleteCookie(vertical, response);
            rememberMeService.removeAttemptsSessionAttribute(vertical, request);
        }
        return isValidAnswer;
    }
}