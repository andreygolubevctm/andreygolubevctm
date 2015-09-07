package com.ctm.router.health;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.HealthAltPriceException;
import com.ctm.exceptions.RouterException;
import com.ctm.model.content.Content;
import com.ctm.model.health.form.HealthRequest;
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


        if (data == null || data.getQuote() == null) {
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

            boolean isShowAll = StringUtils.equals(data.getQuote().getShowAll(), "Y");
            boolean isOnResultsPage = StringUtils.equals(data.getQuote().getOnResultsPage(), "Y");
            if (isShowAll && isOnResultsPage) {
                PremiumRange summary = service.getSummary(brand, data);
                info.setPremiumRange(summary);
            }

            Content alternatePricingActive = null;
            try {
                Date serverDate = ApplicationService.getApplicationDate(context.getHttpServletRequest());
                PageSettings pageSettings = SettingsService.getPageSettingsForPage(context.getHttpServletRequest());
                Integer styleCodeId = pageSettings.getBrandId();
                Integer verticalId = pageSettings.getVertical().getId();
                alternatePricingActive = ContentService.getInstance().getContent("alternatePricingActive", styleCodeId, verticalId, serverDate, true);
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

            PricesObj<HealthResult> results = new PricesObj<>();
            results.setResult(quotes.getRight());
            results.setInfo(info);
            info.setPricesHaveChanged(quotes.getLeft());

            return new ResultsWrapper(results);

        } catch (Exception e) {
            throw new RouterException(e);
        }
    }

}
