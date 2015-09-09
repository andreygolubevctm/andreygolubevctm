package com.ctm.router.health;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.HealthAltPriceException;
import com.ctm.exceptions.RouterException;
import com.ctm.model.CompetitionEntry;
import com.ctm.model.content.Content;
import com.ctm.model.health.form.*;
import com.ctm.model.health.results.HealthResult;
import com.ctm.model.health.results.InfoHealth;
import com.ctm.model.health.results.PremiumRange;
import com.ctm.model.resultsData.PricesObj;
import com.ctm.model.resultsData.ResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.ApplicationService;
import com.ctm.services.ContentService;
import com.ctm.services.SettingsService;
import com.ctm.services.health.HealthQuoteService;
import com.ctm.services.tracking.TrackingKeyService;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.XmlNode;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.Date;
import java.util.List;

@Path("/health")
public class HealthQuoteRouter extends CommonQuoteRouter<HealthRequest> {

    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getHealthQuote(@Context MessageContext context, @FormParam("") final HealthRequest data) {

        // Initialise request
        Brand brand = initRouter(context);
        updateClientIP(context, data); // TODO check IP Address is correct


        HealthQuote quote = data.getQuote();
        if (data == null || quote == null) {
            throw new RouterException("Data quote is missing");
        }

        HealthQuoteService service = new HealthQuoteService();
//        final List<SchemaValidationError> errors = service.validateRequest(data, "quote");

//        if(errors.size() > 0){
//            throw new RouterException("Invalid request"); // TODO pass validation errors to client
//        }

        try {

            InfoHealth info = new InfoHealth();
            info.setTransactionId(data.getTransactionId());

            boolean isShowAll = StringUtils.equals(quote.getShowAll(), "Y");
            boolean isOnResultsPage = StringUtils.equals(quote.getOnResultsPage(), "Y");
            if (isShowAll && isOnResultsPage) {
                PremiumRange summary = service.getSummary(brand, data);
                info.setPremiumRange(summary);
            }

            Content alternatePricingActive = null;
            boolean competitionEnabled = false;
            try {
                Date serverDate = ApplicationService.getApplicationDate(context.getHttpServletRequest());
                PageSettings pageSettings = SettingsService.getPageSettingsForPage(context.getHttpServletRequest());
                Integer styleCodeId = pageSettings.getBrandId();
                Integer verticalId = pageSettings.getVertical().getId();
                ContentService contentService = ContentService.getInstance();
                alternatePricingActive = contentService.getContent("alternatePricingActive", styleCodeId, verticalId, serverDate, true);
                competitionEnabled = StringUtils.equalsIgnoreCase(ContentService.getContentValue(context.getHttpServletRequest(), "competitionEnabled"), "Y");
            } catch(ConfigSettingException | DaoException e) {
                throw new HealthAltPriceException(e.getMessage(), e);
            }

            final Pair<Boolean, List<HealthResult>> quotes = service.getQuotes(brand, data, alternatePricingActive);

            try {
                String trackingKey = TrackingKeyService.generate(
                        context.getHttpServletRequest(), new Long(data.getTransactionId()));
                info.setTrackingKey(trackingKey);
            } catch (Exception e) {
                throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
            }

            ContactDetails contactDetails = quote.getContactDetails();
            String firstName = StringUtils.trim(contactDetails.getName());
            String email = StringUtils.trim(contactDetails.getEmail());
            String phoneNumber;
            ContactNumber contactNumber = contactDetails.getContactNumber();
            if (StringUtils.isNotBlank(contactNumber.getMobile())) {
                phoneNumber = StringUtils.trim(contactNumber.getMobile());
            } else {
                phoneNumber = StringUtils.trim(contactNumber.getOther());
            }
            String concat = firstName +  "::" + email + "::" + phoneNumber;

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
                try {
                    updateCompetitionEntry(context, entry);
                    addCompetitionEntry(context, data.getTransactionId(), entry);
                } catch (Exception e) {
                    LOGGER.error("Error while adding competition entry", e);
                }

                // add to the data bucket competition/previous

                if (competitionNode == null) {
                    competitionNode = new XmlNode("competition");
                    contactDetailsNode.addChild(competitionNode);
                }

                competitionNode.addChild(new XmlNode("previous", concat));
            }

            PricesObj<HealthResult> results = new PricesObj<>();
            results.setResult(quotes.getRight());
            results.setInfo(info);
            info.setPricesHaveChanged(quotes.getLeft());

            return new ResultsWrapper(results);

        } catch (Exception e) {
            throw new RouterException(e);
        }
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

    private void updateCompetitionEntry(MessageContext context, CompetitionEntry entry) {
        try {
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
        } catch (Exception e) {
            LOGGER.error("Error while updating competition entry");
            throw new RouterException(e);
        }
    }

}
