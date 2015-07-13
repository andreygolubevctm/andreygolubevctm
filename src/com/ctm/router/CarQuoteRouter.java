package com.ctm.router;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.AvailableType;
import com.ctm.model.Info;
import com.ctm.model.Results;
import com.ctm.model.ResultsWrapper;
import com.ctm.model.car.CarProduct;
import com.ctm.model.car.CarResult;
import com.ctm.model.car.Views;
import com.ctm.model.car.form.CarQuote;
import com.ctm.model.car.form.CarRequest;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.session.SessionData;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.Vertical;
import com.ctm.providers.Request;
import com.ctm.providers.ResultPropertiesBuilder;
import com.ctm.providers.car.carquote.RequestAdapter;
import com.ctm.providers.car.carquote.ResponseAdapter;
import com.ctm.providers.car.carquote.model.request.CarQuoteRequest;
import com.ctm.providers.car.carquote.model.response.CarResponse;
import com.ctm.services.ApplicationService;
import com.ctm.services.ResultsService;
import com.ctm.services.SessionDataService;
import com.ctm.services.car.CarVehicleSelectionService;
import com.ctm.services.tracking.TrackingKeyService;
import com.ctm.web.validation.CommencementDateValidation;
import com.disc_au.web.go.Data;
import com.fasterxml.jackson.annotation.JsonView;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.jaxrs.json.JacksonJsonProvider;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static java.util.Arrays.asList;

@Path("/car")
public class CarQuoteRouter {

    public static final String QUOTE_URL = "quoteBackendUrl";

    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getCarQuote(@Context MessageContext context, @FormParam("") final CarRequest data) {


        ApplicationService.setVerticalCodeOnRequest(context.getHttpServletRequest(), "CAR");

        SessionDataService service = new SessionDataService();

        Brand brand;
        try {
            // Update the transactionId with the current transactionId from the session
            Data dataForTransactionId = service.getDataForTransactionId(context.getHttpServletRequest(), data.getTransactionId(), true);
            data.setTransactionId(dataForTransactionId.getString("current/transactionId"));
            brand = ApplicationService.getBrandFromRequest(context.getHttpServletRequest());
        } catch (DaoException e) {
            throw new RouterException(e);
        } catch (SessionException e) {
            throw new RouterException(e);
        }


        if (data == null || data.getQuote() == null) {
            throw new RouterException("Data quote is missing");
        }

        // add the clientIpAddress
        String clientIpAddress = null;


        SessionData sessionDataFromSession = service.getSessionDataFromSession(context.getHttpServletRequest());
        if (sessionDataFromSession != null) {
            Data sessionDataForTransactionId = sessionDataFromSession.getSessionDataForTransactionId(data.getTransactionId());
            if (sessionDataForTransactionId != null) {
                clientIpAddress = (String) sessionDataForTransactionId.get("quote/clientIpAddress");
            }
        }
        if (StringUtils.isBlank(clientIpAddress)) {
            clientIpAddress = context.getHttpServletRequest().getRemoteAddr();
        }
        data.setClientIpAddress(clientIpAddress);

        final CarQuote quote = data.getQuote();

        // Fix the commencement date if prior to the current date
        if (quote.getOptions() != null) {
            String sanitisedCommencementDate = quote.getOptions().getCommencementDate();
            // Fix the commencement date if prior to the current date
            if (!CommencementDateValidation.isValid(quote.getOptions().getCommencementDate(), "dd/MM/yyyy")) {
                try {
                    sanitisedCommencementDate = CommencementDateValidation.getToday("dd/MM/yyyy");
                } catch (Exception e) {
                    throw new RouterException(e);
                }
            }

            if (!StringUtils.equals(sanitisedCommencementDate, quote.getOptions().getCommencementDate())) {
                quote.getOptions().setCommencementDate(sanitisedCommencementDate);
            }
        }

        Request request = new Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(clientIpAddress);
        request.setTransactionId(Long.parseLong(data.getTransactionId()));
        final CarQuoteRequest carQuoteRequest = RequestAdapter.adapt(data);
        request.setPayload(carQuoteRequest);

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

        final Vertical vertical = brand.getVerticalByCode(Vertical.VerticalType.CAR.getCode());

        final ConfigSetting configSetting = vertical.getSettingForName(QUOTE_URL);

        final Response response = WebClient.create(configSetting.getValue(), asList(new JacksonJsonProvider(objectMapper)))
                .path("quote")
                .type(MediaType.APPLICATION_JSON_TYPE)
                .accept(MediaType.APPLICATION_JSON_TYPE)
                .post(request);

        final CarResponse carResponse = response.readEntity(CarResponse.class);


        final List<CarResult> carResults = ResponseAdapter.adapt(carResponse);

        saveResults(data, carResults);

        Results<CarResult> results = new Results<>();

        Info info = new Info();
        info.setTransactionId(data.getTransactionId());
        try {
            String trackingKey = TrackingKeyService.generate(
                    context.getHttpServletRequest(), new Long(data.getTransactionId()));
            info.setTrackingKey(trackingKey);
        } catch (Exception e) {
            throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
        }

        results.setInfo(info);
        results.setResult(carResults);

        return new ResultsWrapper(results);
    }

    private void saveResults(CarRequest request, List<CarResult> results) {
        String leadFeedInfo = request.getQuote().createLeadFeedInfo();

        LocalDate validUntil = new LocalDate().plusDays(30);

        DateTimeFormatter emailDateFormat = DateTimeFormat.forPattern("dd MMMMM yyyy");
        DateTimeFormatter normalFormat = DateTimeFormat.forPattern("yyyy-MM-dd");

        List<ResultProperty> resultProperties = new ArrayList<>();
        for (CarResult result : results) {
            if (AvailableType.Y.equals(result.getAvailable())) {
                result.setLeadfeedinfo(leadFeedInfo);

                ResultPropertiesBuilder builder = new ResultPropertiesBuilder(request.getTransactionId(),
                        result.getProductId());

                builder.addResult("leadfeedinfo", leadFeedInfo)
                        .addResult("validateDate/display", emailDateFormat.print(validUntil))
                        .addResult("validateDate/normal", normalFormat.print(validUntil))
                        .addResult("productId", result.getProductId())
                        .addResult("productDes", result.getProviderProductName())
                        .addResult("excess/total", result.getExcess())
                        .addResult("headline/name", result.getProductName())
                        .addResult("quoteUrl", result.getQuoteUrl())
                        .addResult("telNo", result.getContact().getPhoneNumber())
                        .addResult("openingHours", result.getContact().getCallCentreHours())
                        .addResult("leadNo", result.getQuoteNumber())
                        .addResult("brandCode", result.getBrandCode());

                resultProperties.addAll(builder.getResultProperties());
            }
        }

        ResultsService.saveResultsProperties(resultProperties);
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
