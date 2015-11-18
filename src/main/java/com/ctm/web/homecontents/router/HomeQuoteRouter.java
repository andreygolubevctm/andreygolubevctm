package com.ctm.web.homecontents.router;

import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ResultsObj;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.homecontents.model.form.HomeRequest;
import com.ctm.web.homecontents.model.results.HomeMoreInfo;
import com.ctm.web.homecontents.model.results.HomeResult;
import com.ctm.web.homecontents.services.HomeQuoteService;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HOME;

@Path("/home")
public class HomeQuoteRouter extends CommonQuoteRouter {

    private final HomeQuoteService homeService = new HomeQuoteService();

    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getHomeQuote(@Context MessageContext context, @FormParam("") final HomeRequest data) throws Exception {

        Vertical.VerticalType vertical = HOME;

        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data);

        homeService.validateRequest(data, vertical.getCode());

        final List<HomeResult> quotes = homeService.getQuotes(brand, data);

        homeService.writeTempResultDetails(context, data, quotes);
        ResultsObj<HomeResult> results = new ResultsObj<>();
        results.setResult(quotes);
        results.setInfo(generateInfoKey(data, context));

        return new ResultsWrapper(results);
    }

    @GET
    @Path("/more_info/get.json")
    @Produces("application/json")
    public HomeMoreInfo moreInfo(@Context MessageContext context, @QueryParam("code") String productId,
                                 @QueryParam("type") String type, @QueryParam(value = "environmentOverride") String environmentOverride) throws Exception {
        Brand brand = initRouter(context, HOME);
        HomeQuoteService homeService = new HomeQuoteService();
        return homeService.getMoreInfo(brand, productId, type, Optional.ofNullable(environmentOverride));
    }

    @Override
    protected Vertical.VerticalType getVertical() {
        return Vertical.VerticalType.HOME;
    }
}
