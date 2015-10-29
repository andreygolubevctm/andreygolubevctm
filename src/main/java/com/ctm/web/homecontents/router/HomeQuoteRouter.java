package com.ctm.web.homecontents.router;

import com.ctm.exceptions.RouterException;
import com.ctm.web.homecontents.model.form.HomeRequest;
import com.ctm.web.homecontents.model.results.HomeMoreInfo;
import com.ctm.web.homecontents.model.results.HomeResult;
import com.ctm.model.resultsData.Info;
import com.ctm.model.resultsData.ResultsObj;
import com.ctm.model.resultsData.ResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.web.homecontents.services.HomeQuoteService;
import com.ctm.services.tracking.TrackingKeyService;
import com.ctm.web.core.web.validation.SchemaValidationError;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.List;
import java.util.Optional;

@Path("/home")
public class HomeQuoteRouter extends CommonQuoteRouter {

    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getHomeQuote(@Context MessageContext context, @FormParam("") final HomeRequest data) {

        // Initialise request
        Brand brand = initRouter(context);
        updateClientIP(context, data); // TODO check IP Address is correct


        if (data == null || data.getQuote() == null) {
            throw new RouterException("Data quote is missing");
        }

        HomeQuoteService homeService = new HomeQuoteService();
        final List<SchemaValidationError> errors = homeService.validateRequest(data, "");

        if(errors.size() > 0){
            throw new RouterException("Invalid request"); // TODO pass validation errors to client
        }

        try {
            final List<HomeResult> quotes = homeService.getQuotes(brand, data);

            Info info = new Info();
            info.setTransactionId(data.getTransactionId());
            try {
                String trackingKey = TrackingKeyService.generate(
                        context.getHttpServletRequest(), new Long(data.getTransactionId()));
                info.setTrackingKey(trackingKey);
            } catch (Exception e) {
                throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
            }

            homeService.writeTempResultDetails(context,data,quotes);
            ResultsObj<HomeResult> results = new ResultsObj<>();
            results.setResult(quotes);
            results.setInfo(info);

            return new ResultsWrapper(results);
        } catch (Exception e) {
            throw new RouterException(e);
        }
    }

    @GET
    @Path("/more_info/get.json")
    @Produces("application/json")
    public HomeMoreInfo moreInfo(@Context MessageContext context, @QueryParam("code") String productId,
                                @QueryParam("type") String type, @QueryParam(value = "environmentOverride") String environmentOverride) {
        Brand brand = initRouter(context);
        HomeQuoteService homeService = new HomeQuoteService();
        return homeService.getMoreInfo(brand, productId, type, Optional.ofNullable(environmentOverride));
    }

}
