package com.ctm.router.car;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.model.car.CarProduct;
import com.ctm.model.car.Views;
import com.ctm.model.car.form.CarRequest;
import com.ctm.model.car.results.CarResult;
import com.ctm.model.resultsData.ResultsObj;
import com.ctm.model.resultsData.ResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.ApplicationService;
import com.ctm.services.car.CarQuoteService;
import com.ctm.services.car.CarVehicleSelectionService;
import com.fasterxml.jackson.annotation.JsonView;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.Date;
import java.util.List;

import static com.ctm.model.settings.Vertical.VerticalType.CAR;

@Path("/car")
public class CarQuoteRouter extends CommonQuoteRouter<CarRequest> {

    private final CarQuoteService carService = new CarQuoteService();

    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getCarQuote(@Context MessageContext context, @FormParam("") final CarRequest data) throws Exception {

        // Initialise request
        final Vertical.VerticalType vertical = CAR;
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data);

        carService.validateRequest(data, "quote");

        final List<CarResult> quotes = carService.getQuotes(brand, data);

        carService.writeTempResultDetails(context, data, quotes);
        ResultsObj<CarResult> results = new ResultsObj<>();
        results.setResult(quotes);
        results.setInfo(generateInfoKey(data, context));

        return new ResultsWrapper(results);

    }

    @GET
    @Path("/more_info/get.json")
    @Produces("application/json")
    @JsonView(Views.MoreInfoView.class)
    public CarProduct moreInfo(@Context MessageContext context, @QueryParam("code") String productId) throws DaoException {

        if (productId == null) {
            throw new RouterException("Expecting productId");
        }

        Brand brand = ApplicationService.getBrandFromRequest(context.getHttpServletRequest());

        Date applicationDate = ApplicationService.getApplicationDate(context.getHttpServletRequest());
        return CarVehicleSelectionService.getCarProduct(applicationDate, productId, brand.getId());
    }
}
