package com.ctm.router.car;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.model.car.CarProduct;
import com.ctm.model.car.Views;
import com.ctm.model.car.form.CarRequest;
import com.ctm.model.car.results.CarResult;
import com.ctm.model.resultsData.Info;
import com.ctm.model.resultsData.ResultsObj;
import com.ctm.model.resultsData.ResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.ApplicationService;
import com.ctm.services.car.CarQuoteService;
import com.ctm.services.car.CarVehicleSelectionService;
import com.ctm.services.tracking.TrackingKeyService;
import com.fasterxml.jackson.annotation.JsonView;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.Date;
import java.util.List;

@Path("/car")
public class CarQuoteRouter extends CommonQuoteRouter<CarRequest> {



    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getCarQuote(@Context MessageContext context, @FormParam("") final CarRequest data) {

        // Initialise request
        Brand brand = initRouter(context);
        updateClientIP(context, data); // TODO check IP Address is correct


        if (data == null || data.getQuote() == null) {
            throw new RouterException("Data quote is missing");
        }

        CarQuoteService carService = new CarQuoteService();
        final List<CarResult> quotes = carService.getQuotes(brand, data);

        Info info = new Info();
        info.setTransactionId(data.getTransactionId());
        try {
            String trackingKey = TrackingKeyService.generate(
                    context.getHttpServletRequest(), new Long(data.getTransactionId()));
            info.setTrackingKey(trackingKey);
        } catch (Exception e) {
            throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
        }

        ResultsObj<CarResult> results = new ResultsObj<>();
        results.setResult(quotes);
        results.setInfo(info);

        return new ResultsWrapper(results);
    }

    @GET
    @Path("/more_info/get.json")
    @Produces("application/json")
    @JsonView(Views.MoreInfoView.class)
    public CarProduct moreInfo(@Context MessageContext context, @QueryParam("code") String productId) {

        if (productId == null) {
            throw new RouterException("Expecting productId");
        }

        Brand brand;
        try {
            // Update the transactionId with the current transactionId from the session
            brand = ApplicationService.getBrandFromRequest(context.getHttpServletRequest());
        } catch (DaoException e) {
            throw new RouterException(e);
        }

        Date applicationDate = ApplicationService.getApplicationDate(context.getHttpServletRequest());
        CarProduct carProduct = CarVehicleSelectionService.getCarProduct(applicationDate, productId, brand.getId());


        ObjectMapper objectMapper = new ObjectMapper();
        ObjectWriter objectWriter = objectMapper.writerWithView(Views.MoreInfoView.class);

        try {
            System.out.println(objectWriter.writeValueAsString(carProduct));
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return carProduct;
    }
}
