package com.ctm.web.health.services;

import com.ctm.web.core.competition.services.CompetitionService;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.CompetitionEntry;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonQuoteService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.health.model.form.*;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.ctm.web.health.quote.model.RequestAdapter;
import com.ctm.web.health.quote.model.ResponseAdapter;
import com.ctm.web.health.quote.model.request.HealthQuoteRequest;
import com.ctm.web.health.quote.model.response.HealthResponse;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.cxf.jaxrs.ext.MessageContext;

import java.io.IOException;
import java.util.List;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

public class HealthQuoteService extends CommonQuoteService<HealthQuote, HealthQuoteRequest, HealthResponse> {

    private final CompetitionService competitionService;

    public HealthQuoteService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
        this.competitionService = new CompetitionService(new SessionDataServiceBean());
    }

    public Pair<Boolean, List<HealthQuoteResult>> getQuotes(Brand brand, HealthRequest data, Content alternatePricingContent, boolean isSimples) throws DaoException, IOException, ServiceConfigurationException {
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data, alternatePricingContent, isSimples);
        final HealthResponse healthResponse = sendRequest(brand, HEALTH, "healthQuoteServiceBER", Endpoint.QUOTE, data, quoteRequest, HealthResponse.class);
        return ResponseAdapter.adapt(data, healthResponse, alternatePricingContent);
    }

    public Data healthCompetitionEntry(MessageContext context, HealthRequest data, HealthQuote quote, boolean competitionEnabled, Data dataBucket) throws ConfigSettingException, DaoException, EmailDetailsException {
        ContactDetails contactDetails = quote.getContactDetails();
        String firstName = StringUtils.trim(contactDetails.getName());
        String email = StringUtils.trim(contactDetails.getEmail());
        String phoneNumber;
        if (contactDetails.getContactNumber() != null) {
            ContactNumber contactNumber = contactDetails.getContactNumber();
            if (StringUtils.isNotBlank(contactNumber.getMobile())) {
                phoneNumber = StringUtils.trim(contactNumber.getMobile());
            } else {
                phoneNumber = StringUtils.trim(contactNumber.getOther());
            }
        } else {
            phoneNumber = contactDetails.getFlexiContactNumberinput();
        }
        String concat = firstName + "::" + email + "::" + phoneNumber;

        XmlNode health = dataBucket.getFirstChild("health");
        XmlNode contactDetailsNode = health.getFirstChild("contactDetails");
        XmlNode competitionNode = contactDetailsNode.getFirstChild("competition");

        // Check for competition
        if (competitionEnabled && optInCompetition(quote) && notEntered(competitionNode, concat)) {

            CompetitionEntry entry = new CompetitionEntry();

            entry.setFirstName(firstName);
            entry.setEmail(email);
            entry.setPhoneNumber(phoneNumber);
            updateCompetitionEntry(context, entry);
            competitionService.addToCompetitionEntry(context, data.getTransactionId(), entry);
            // add to the data bucket competition/previous

            if (competitionNode == null) {
                competitionNode = new XmlNode("competition");
                contactDetailsNode.addChild(competitionNode);
            }

            competitionNode.addChild(new XmlNode("previous", concat));
        }
        return dataBucket;
    }


    private boolean optInCompetition(HealthQuote quote) {
        Competition competition = quote.getContactDetails().getCompetition();
        return competition != null && StringUtils.equalsIgnoreCase(competition.getOptin(), "Y");
    }

    private boolean notEntered(XmlNode competitionNode, String concat) {
        if (competitionNode != null) {
            XmlNode previous = competitionNode.getFirstChild("previous");
            if (previous != null && StringUtils.equalsIgnoreCase(previous.getText(), concat)) {
                return false;
            }
        }
        return true;
    }

    private void updateCompetitionEntry(MessageContext context, CompetitionEntry entry) throws ConfigSettingException, DaoException {
        String competitionSecret = StringUtils.defaultIfEmpty(ContentService.getContentValue(context.getHttpServletRequest(), "competitionSecret"), "");

        switch (competitionSecret) {
            case "vU9CD4NjT3S6p7a83a4t":
                entry.setCompetitionId(26);
                entry.setSource("AugustHealthPromo2015$5000");
                break;
            case "kSdRdpu5bdM5UkKQ8gsK":
                entry.setCompetitionId(24);
                entry.setSource("AugustHealthPromo2015$1000");
                break;
            case "C7F9FILY0qe02X98rXCH":
                entry.setCompetitionId(19);
                entry.setSource("MayHealthPromo2015$1000");
                break;
            case "1NjmJ507mwUnX81Lj96b":
                entry.setCompetitionId(20);
                entry.setSource("YHOO-MayPromo2015$1000");
                break;
            case "1F6F87144375AD8BAED4D53F8CF5B":
                entry.setCompetitionId(15);
                entry.setSource("Feb2015HealthJEEPPromo");
                break;
        }
    }

}

