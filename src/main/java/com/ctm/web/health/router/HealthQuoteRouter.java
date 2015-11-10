package com.ctm.web.health.router;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.CompetitionEntry;
import com.ctm.web.core.model.resultsData.NoResults;
import com.ctm.web.core.model.resultsData.NoResultsObj;
import com.ctm.web.core.model.resultsData.PricesObj;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.tracking.TrackingKeyService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.health.model.form.*;
import com.ctm.web.health.model.results.HealthResult;
import com.ctm.web.health.model.results.InfoHealth;
import com.ctm.web.health.model.results.PremiumRange;
import com.ctm.web.health.services.HealthQuoteService;
import com.ctm.web.health.services.HealthQuoteSummaryService;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Path("/health")
public class HealthQuoteRouter extends CommonQuoteRouter<HealthRequest> {

    private final HealthQuoteService healthQuoteService = new HealthQuoteService();

    private final HealthQuoteSummaryService healthQuoteSummaryService = new HealthQuoteSummaryService();

    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getHealthQuote(@Context MessageContext context, @FormParam("") final HealthRequest data) throws Exception {

        Vertical.VerticalType vertical = HEALTH;


        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data);

//        HealthQuoteTokenService healthQuoteTokenService = new HealthQuoteTokenService();
//        healthQuoteTokenService.init(context.getHttpServletRequest(), getPageSettingsByCode(brand, vertical));
//
//        // throw an exception when invalid token
//        if (!healthQuoteTokenService.validToken()) {
//            throw new RouterException("Invalid token");
//        }

        InfoHealth info = new InfoHealth();
        info.setTransactionId(data.getTransactionId());

        final HealthQuote quote = data.getQuote();


        boolean isShowAll = StringUtils.equals(quote.getShowAll(), "Y");
        boolean isOnResultsPage = StringUtils.equals(quote.getOnResultsPage(), "Y");
        if (isShowAll && isOnResultsPage) {
            PremiumRange summary = healthQuoteSummaryService.getSummary(brand, data);
            info.setPremiumRange(summary);
        }


        final Date serverDate = ApplicationService.getApplicationDate(context.getHttpServletRequest());
        final PageSettings pageSettings = getPageSettingsByCode(brand, vertical);
        final Content alternatePricingActive = ContentService.getInstance()
                .getContent("alternatePricingActive", pageSettings.getBrandId(), pageSettings.getVertical().getId(), serverDate, true);
        final boolean competitionEnabled = StringUtils.equalsIgnoreCase(ContentService.getContentValue(context.getHttpServletRequest(), "competitionEnabled"), "Y");

        final Pair<Boolean, List<HealthResult>> quotes = healthQuoteService.getQuotes(brand, data, alternatePricingActive);

        if (quotes.getValue().isEmpty()) {

            NoResultsObj results = new NoResultsObj();

            NoResults noResults = new NoResults();
            noResults.setAvailable(AvailableType.N);
            noResults.setProductId("PHIO-*NONE");
            noResults.setServiceName("PHIO");

            results.setInfo(info);
            results.setResult(Collections.singletonList(noResults));

            // create resultsWrapper with the token
//            return healthQuoteTokenService.createResultsWrapper(context.getHttpServletRequest(), data.getTransactionId(), results);
            new ResultsWrapper(results);
        } else {

            String trackingKey = TrackingKeyService.generate(
                    context.getHttpServletRequest(), data.getTransactionId());
            info.setTrackingKey(trackingKey);

            Data dataBucket = healthCompetitionEntry(context, data, quote, competitionEnabled);

            PricesObj<HealthResult> results = new PricesObj<>();
            results.setResult(quotes.getRight());
            results.setInfo(info);
            info.setPricesHaveChanged(quotes.getLeft());

            if (!isShowAll) {

                if (dataBucket.hasChild("confirmation")) {
                    dataBucket.removeChild("confirmation");
                }

                XmlNode confirmation = new XmlNode("confirmation");
                dataBucket.addChild(confirmation);
                XmlNode details = new XmlNode("health");
                confirmation.addChild(details);

                details.setText("<![CDATA[" + ObjectMapperUtil.getObjectMapper().writeValueAsString(results) + "]]>");
            }

            // create resultsWrapper with the token
//            return healthQuoteTokenService.createResultsWrapper(context.getHttpServletRequest(), data.getTransactionId(), results);
            return new ResultsWrapper(results);
        }
        return null;

    }

    private Data healthCompetitionEntry(MessageContext context, HealthRequest data, HealthQuote quote, boolean competitionEnabled) throws ConfigSettingException, DaoException, EmailDetailsException {
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

        Data dataBucket = getDataBucket(context, data.getTransactionId());
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
            addCompetitionEntry(context, data.getTransactionId(), entry);
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
