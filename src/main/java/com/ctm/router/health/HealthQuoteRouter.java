package com.ctm.router.health;

import com.ctm.exceptions.RouterException;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.health.results.HealthResult;
import com.ctm.model.health.results.InfoHealth;
import com.ctm.model.health.results.PremiumRange;
import com.ctm.model.resultsData.PricesObj;
import com.ctm.model.resultsData.ResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.health.HealthQuoteService;
import com.ctm.services.tracking.TrackingKeyService;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
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
            PremiumRange summary = service.getSummary(brand, data);

            final List<HealthResult> quotes = service.getQuotes(brand, data);


            InfoHealth info = new InfoHealth();
            info.setTransactionId(data.getTransactionId());
            info.setPremiumRange(summary);

            try {
                String trackingKey = TrackingKeyService.generate(
                        context.getHttpServletRequest(), new Long(data.getTransactionId()));
                info.setTrackingKey(trackingKey);
            } catch (Exception e) {
                throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
            }

            PricesObj<HealthResult> results = new PricesObj<>();
            results.setResult(quotes);
            results.setInfo(info);

            return new ResultsWrapper(results);

        } catch (Exception e) {
            throw new RouterException(e);
        }
    }

}
