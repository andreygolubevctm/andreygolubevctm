package com.ctm.web.life.quote.controller;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.life.form.model.*;
import com.ctm.web.life.form.response.model.LifeResultsWebResponse;
import com.ctm.web.life.services.LifeQuoteService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.IOException;

@Api(basePath = "/rest/life", value = "Life Quote")
@RestController
@RequestMapping("/rest/life")
public class LifeQuoteController extends CommonQuoteRouter<LifeQuoteWebRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeQuoteController.class);

    @Autowired
    private LifeQuoteService lifeQuoteService;

    @Autowired
    public LifeQuoteController(SessionDataServiceBean sessionDataServiceBean,
                               ApplicationService applicationService,
                               IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, applicationService, ipAddressHandler);
    }

    @ApiOperation(value = "quote/get.json", notes = "Request a life quote", produces = "application/json")
    @RequestMapping(value = "/quote/get.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public LifeResultsWebResponse getQuote(@Valid LifeQuoteWebRequest quoteRequest, HttpServletRequest request) throws IOException, ServiceConfigurationException, DaoException {
        Brand brand = initRouter(request, Vertical.VerticalType.LIFE);
        updateTransactionIdAndClientIP(request, quoteRequest);
        final LifeResultsWebResponse quotes = lifeQuoteService.getQuotes(quoteRequest, brand);

        try {
            lifeQuoteService.addCompetition(quoteRequest, request);
        } catch (Exception e) {
            LOGGER.warn("An error occurred while adding competition", e);
        }

        return quotes;
    }
}
