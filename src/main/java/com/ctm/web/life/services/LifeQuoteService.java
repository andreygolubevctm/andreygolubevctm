package com.ctm.web.life.services;

import com.ctm.life.quote.model.request.LifeQuoteRequest;
import com.ctm.web.car.model.request.CarRequest;
import com.ctm.web.car.quote.model.response.CarResponse;
import com.ctm.web.core.competition.services.CompetitionService;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.model.CompetitionEntry;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.*;
import com.ctm.web.life.form.model.*;
import com.ctm.web.life.form.response.model.LifeResultsWebResponse;
import com.ctm.web.life.model.LifeQuoteResponse;
import com.ctm.web.life.quote.adapter.LifeQuoteServiceRequestAdapter;
import com.ctm.web.life.quote.adapter.LifeQuoteServiceResponseAdapter;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.CAR;
import static com.ctm.web.core.model.settings.Vertical.VerticalType.LIFE;

@Component
public class LifeQuoteService {

    private final CommonRequestService<Object, LifeQuoteResponse> requestService;
    @Autowired
    private LifeQuoteServiceRequestAdapter requestAdapter;

    @Autowired
    private LifeQuoteServiceResponseAdapter responseAdapter;

    private final CompetitionService competitionService;

    @Autowired
    public LifeQuoteService(
                            CompetitionService competitionService,
                            CommonRequestService<Object, LifeQuoteResponse> requestService) {
        this.competitionService = competitionService;
        this.requestService = requestService;
    }

    public LifeResultsWebResponse getQuotes(LifeQuoteWebRequest request, Brand brand) throws DaoException, IOException, ServiceConfigurationException {
        LifeQuoteRequest serviceRequest = requestAdapter.adapt(request);
        final LifeQuoteResponse response = requestService.sendQuoteRequest(brand, LIFE, "quoteServiceBER", request,
                serviceRequest, LifeQuoteResponse.class);

        return responseAdapter.adapt(response, request);
    }

    public void addCompetition(LifeQuoteWebRequest quoteRequest, HttpServletRequest request) throws ServiceException {
        final boolean competitionEnabled;
        try {
            competitionEnabled = StringUtils.equalsIgnoreCase(ContentService.getContentValue(request, "competitionEnabled"), "Y");
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

                competitionService.addToCompetitionEntry(request, quoteRequest.getTransactionId(), entry);

            }
        } catch (DaoException | ConfigSettingException e) {
            throw new ServiceException("Failed to add competition. {}" + quoteRequest , e);
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
