package com.ctm.web.car.services;

import com.ctm.web.car.exceptions.CarServiceException;
import com.ctm.web.car.model.form.CarQuote;
import com.ctm.web.car.model.form.CarRequest;
import com.ctm.web.car.model.results.CarResult;
import com.ctm.web.car.quote.model.RequestAdapter;
import com.ctm.web.car.quote.model.ResponseAdapter;
import com.ctm.web.car.quote.model.request.CarQuoteRequest;
import com.ctm.web.car.quote.model.response.CarResponse;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.Request;
import com.ctm.web.core.results.ResultPropertiesBuilder;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.services.CommonQuoteService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.ResultsService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.validation.CommencementDateValidation;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.joda.time.LocalDate;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.CAR;
import static java.util.stream.Collectors.toList;

public class CarQuoteService extends CommonQuoteService<CarQuote, CarQuoteRequest, CarResponse> {

    private static final SessionDataService SESSION_DATA_SERVICE = new SessionDataService();

    public List<CarResult> getQuotes(Brand brand, CarRequest data) throws Exception {

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

        CarResponse carResponse = sendRequest(brand, CAR, "carQuoteServiceBER", "CAR-QUOTE", "quote", data, carQuoteRequest, CarResponse.class);

        final List<CarResult> carResults = ResponseAdapter.adapt(carResponse);

        saveResults(data, carResults);

        return carResults;
    }

    protected void saveResults(CarRequest request, List<CarResult> results) throws Exception {
        ResultsService.saveResultsProperties(getResultProperties(request, results));
    }

    protected List<ResultProperty> getResultProperties(CarRequest request, List<CarResult> results) {

        String leadFeedInfo = request.getQuote().createLeadFeedInfo();

        LocalDate validUntil = new LocalDate().plusDays(30);

        return results.stream()
                    .filter(result -> AvailableType.Y.equals(result.getAvailable()))
                    .map(result -> new ResultPropertiesBuilder(request.getTransactionId(),
                                    result.getProductId())
                                    .addResult("leadfeedinfo", leadFeedInfo)
                                    .addResult("validateDate/display", EMAIL_DATE_FORMAT.print(validUntil))
                                    .addResult("validateDate/normal", NORMAL_FORMAT.print(validUntil))
                                    .addResult("productId", result.getProductId())
                                    .addResult("productDes", result.getProviderProductName())
                                    .addResult("excess/total", result.getExcess())
                                    .addResult("headline/name", result.getProductName())
                                    .addResult("quoteUrl", result.getQuoteUrl())
                                    .addResult("telNo", result.getContact().getPhoneNumber())
                                    .addResult("openingHours", result.getContact().getCallCentreHours())
                                    .addResult("leadNo", result.getQuoteNumber())
                                    .addResult("brandCode", result.getBrandCode())
                                    .getResultProperties()
                    ).flatMap(Collection::stream)
                    .collect(toList());
    }

    public void writeTempResultDetails(MessageContext context, CarRequest data, List<CarResult> quotes) throws SessionException, DaoException {

        Data dataBucket = SESSION_DATA_SERVICE.getDataForTransactionId(context.getHttpServletRequest(), data.getTransactionId().toString(), true);

        final String transactionId = dataBucket.getString("current/transactionId");
        if(transactionId != null){
            data.setTransactionId(Long.parseLong(transactionId));

            XmlNode resultDetails = new XmlNode("tempResultDetails");
            dataBucket.addChild(resultDetails);
            XmlNode results = new XmlNode("results");
            resultDetails.addChild(results);

            quotes.stream()
                .filter(row -> row.getAvailable().equals(AvailableType.Y))
                .forEach(row -> {
                            String productId = row.getProductId();
                            BigDecimal premium = row.getPrice().getAnnualPremium();
                            XmlNode product = new XmlNode(productId);
                            XmlNode headline = new XmlNode("headline");
                            XmlNode lumpSumTotal = new XmlNode("lumpSumTotal", premium.toString());
                            headline.addChild(lumpSumTotal);
                            product.addChild(headline);
                            results.addChild(product);
                        }

                );
        }

    }
}
