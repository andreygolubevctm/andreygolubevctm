package com.ctm.web.life.quote.controller;

import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.CompetitionEntry;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.life.form.model.*;
import com.ctm.web.life.form.response.model.LifeResultsWebResponse;
import com.ctm.web.life.services.LifeQuoteService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
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
import java.util.Optional;

@Api(basePath = "/rest/life", value = "Life Quote")
@RestController
@RequestMapping("/rest/life")
public class LifeQuoteController extends CommonQuoteRouter<LifeQuoteWebRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeQuoteController.class);

    @Autowired
    private LifeQuoteService lifeQuoteService;

    @Autowired
    public LifeQuoteController(SessionDataServiceBean sessionDataServiceBean, ApplicationService applicationService) {
        super(sessionDataServiceBean, applicationService);
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
            addCompetition(quoteRequest, request);
        } catch (Exception e) {
            LOGGER.warn("An error occurred while adding competition", e);
        }

        return quotes;
    }

    private void addCompetition(LifeQuoteWebRequest quoteRequest, HttpServletRequest request) throws DaoException, ConfigSettingException, com.ctm.web.core.email.exceptions.EmailDetailsException {
        final boolean competitionEnabled = StringUtils.equalsIgnoreCase(ContentService.getContentValue(request, "competitionEnabled"), "Y");
        final Optional<LifeQuote> quote = Optional.ofNullable(quoteRequest.getQuote());
        final boolean optInCompetition = quote
                                            .map(LifeQuote::getContactDetails)
                                            .map(ContactDetails::getCompetition)
                                            .map(Competition::getOptin)
                                            .filter(o -> StringUtils.equals(o, "Y"))
                                            .isPresent();

        if (competitionEnabled && optInCompetition) {
            CompetitionEntry entry = new CompetitionEntry();
            final Integer competitionId = Integer.parseInt(ContentService.getContentValue(request, "competitionId"));
            entry.setCompetitionId(competitionId);
            entry.setEmail(quote.map(LifeQuote::getContactDetails)
                    .map(ContactDetails::getEmail)
                    .map(StringUtils::trim)
                    .orElseThrow(() -> new IllegalArgumentException("Email missing")));
            entry.setFirstName(quote.map(LifeQuote::getPrimary)
                    .map(Applicant::getFirstName)
                    .orElseThrow(() -> new IllegalArgumentException("FirstName missing")));
            entry.setLastName(quote.map(LifeQuote::getPrimary)
                    .map(Applicant::getLastname)
                    .orElseThrow(() -> new IllegalArgumentException("Lastname missing")));
            entry.setPhoneNumber(quote.map(LifeQuote::getContactDetails)
                    .map(ContactDetails::getContactNumber)
                    .orElseThrow(() -> new IllegalArgumentException("ContactNumber missing")));
            entry.setPhoneNumberRequired(true);
            entry.setSource(getSource(competitionId));

            addCompetitionEntry(request, quoteRequest.getTransactionId(), entry);

        }
    }

    private String getSource(Integer competitionId) {
        switch (competitionId) {
            case 13 : return "Life$1000CashNov2014";
            case 17 : return "Life$1000CashFeb2015";
            case 22 : return "Life$1000CashJune2015";
            case 27 : return "Life$5000Cash2015";
            default: return "OctPromo1000grubs";
        }
    }
}
