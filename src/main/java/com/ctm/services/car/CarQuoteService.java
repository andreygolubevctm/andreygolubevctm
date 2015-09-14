package com.ctm.services.car;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.*;
import com.ctm.model.QuoteServiceProperties;
import com.ctm.model.car.form.CarQuote;
import com.ctm.model.car.form.CarRequest;
import com.ctm.model.car.results.CarResult;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.model.settings.Brand;
import com.ctm.providers.Request;
import com.ctm.providers.ResultPropertiesBuilder;
import com.ctm.providers.car.carquote.model.RequestAdapter;
import com.ctm.providers.car.carquote.model.ResponseAdapter;
import com.ctm.providers.car.carquote.model.request.CarQuoteRequest;
import com.ctm.providers.car.carquote.model.response.CarResponse;
import com.ctm.services.CommonQuoteService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.ResultsService;
import com.ctm.services.SessionDataService;
import com.ctm.web.validation.CommencementDateValidation;
import com.ctm.logging.XMLOutputWriter;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.XmlNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;
import static com.ctm.model.settings.Vertical.VerticalType.CAR;
import static com.ctm.logging.XMLOutputWriter.REQ_OUT;

public class CarQuoteService extends CommonQuoteService<CarQuote> {

	private static final Logger LOGGER = LoggerFactory.getLogger(CarQuoteService.class);

    public List<CarResult> getQuotes(Brand brand, CarRequest data) {

        CarQuote quote = data.getQuote();

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
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());

        EnvironmentService environmentService = new EnvironmentService();

        if(
            environmentService.getEnvironment() == EnvironmentService.Environment.LOCALHOST ||
            environmentService.getEnvironment() == EnvironmentService.Environment.NXI ||
            environmentService.getEnvironment() == EnvironmentService.Environment.NXS
        ) {
            // Check if AuthToken provided and use as filter if available
            // It is acceptable to throw exceptions here as provider key is checked
            // when page loaded so technically should not reach here otherwise.
            String authToken = quote.getFilter().getAuthToken();

            if (authToken != null) {
                ProviderFilterDao providerFilterDAO = new ProviderFilterDao();
                try {
                    ArrayList<String> providerCode = providerFilterDAO.getProviderDetailsByAuthToken(authToken);
                    if (providerCode.isEmpty()) {
                        throw new CarServiceException("Invalid Auth Token");
                    } else {
                        quote.getFilter().setProviders(providerCode);
                    }
                } catch (DaoException e) {
                    throw new CarServiceException("Auth Token Error", e);
                }
                // Provider Key is mandatory in NXS
            } else if (EnvironmentService.getEnvironmentAsString().equalsIgnoreCase("nxs")) {
                throw new CarServiceException("Provider Key required in '" + EnvironmentService.getEnvironmentAsString() + "' environment");
            }
        }

        final CarQuoteRequest carQuoteRequest = RequestAdapter.adapt(data);
        request.setPayload(carQuoteRequest);

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

        // Get URL of car-quote service
        QuoteServiceProperties serviceProperties = getQuoteServiceProperties("carQuoteServiceBER", brand, CAR.getCode(), data);

        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_CAR-QUOTE" , serviceProperties.getDebugPath());
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(serviceProperties.getTimeout());
            connection.setReadTimeout(serviceProperties.getTimeout());
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = connection.get(serviceProperties.getServiceUrl()+"/quote");
            CarResponse carResponse = objectMapper.readValue(response, CarResponse.class);

            // Log response
            writer.lastWriteXmlToFile(response);

            final List<CarResult> carResults = ResponseAdapter.adapt(carResponse);

            saveResults(data, carResults);

            return carResults;

        }catch(IOException e){
            LOGGER.error("Error parsing or connecting to car-quote {}, {}", kv("brand", brand), kv("carRequest", data), e);
        }

        return null;
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

    public void writeTempResultDetails(MessageContext context, CarRequest data, List<CarResult> quotes) {

        SessionDataService service = new SessionDataService();

        try {
            Data dataBucket = service.getDataForTransactionId(context.getHttpServletRequest(), data.getTransactionId().toString(), true);

            if(dataBucket != null && dataBucket.getString("current/transactionId") != null){
                data.setTransactionId(Long.parseLong(dataBucket.getString("current/transactionId")));

                XmlNode resultDetails = new XmlNode("tempResultDetails");
                dataBucket.addChild(resultDetails);
                XmlNode results = new XmlNode("results");

                Iterator<CarResult> quotesIterator = quotes.iterator();
                while (quotesIterator.hasNext()) {
                    CarResult row = quotesIterator.next();
                    if(row.getAvailable().equals(AvailableType.Y)) {
                        String productId = row.getProductId();
                        BigDecimal premium = row.getPrice().getAnnualPremium();
                        XmlNode product = new XmlNode(productId);
                        XmlNode headline = new XmlNode("headline");
                        XmlNode lumpSumTotal = new XmlNode("lumpSumTotal", premium.toString());
                        headline.addChild(lumpSumTotal);
                        product.addChild(headline);
                        results.addChild(product);
                    }
                }
                resultDetails.addChild(results);
            }
        } catch (DaoException | SessionException e) {
            LOGGER.error("Failed writing temp result details {}, {}", kv("transactionId", data.getTransactionId()), kv("carRequest", data));
        }
    }
}
