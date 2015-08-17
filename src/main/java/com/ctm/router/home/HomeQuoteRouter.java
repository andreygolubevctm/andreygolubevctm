package com.ctm.router.home;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.model.home.HomeProduct;
import com.ctm.model.home.form.HomeRequest;
import com.ctm.model.home.results.HomeResult;
import com.ctm.model.resultsData.Info;
import com.ctm.model.resultsData.ResultsObj;
import com.ctm.model.resultsData.ResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.ApplicationService;
import com.ctm.services.home.HomeQuoteService;
import com.ctm.services.home.HomeService;
import com.ctm.services.tracking.TrackingKeyService;
import com.ctm.web.validation.SchemaValidationError;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.Date;
import java.util.List;

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
    public HomeProduct moreInfo(@Context MessageContext context, @QueryParam("code") String productId,
                                @QueryParam("type") String type) {

        if (productId == null) {
            throw new RouterException("Expecting code");
        }

        Brand brand;
        try {
            // Update the transactionId with the current transactionId from the session
            brand = ApplicationService.getBrandFromRequest(context.getHttpServletRequest());
        } catch (DaoException e) {
            throw new RouterException(e);
        }

        Date applicationDate = ApplicationService.getApplicationDate(context.getHttpServletRequest());
        HomeProduct product = HomeService.getHomeProduct(applicationDate, productId, type, brand.getId());
        return product;
    }


}
