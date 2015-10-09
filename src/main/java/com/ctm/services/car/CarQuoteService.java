package com.ctm.services.car;

import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.car.form.CarQuote;
import com.ctm.model.car.form.CarRequest;
import com.ctm.model.car.results.CarResult;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.model.settings.Brand;
import com.ctm.providers.ResultPropertiesBuilder;
import com.ctm.providers.car.carquote.model.RequestAdapter;
import com.ctm.providers.car.carquote.model.ResponseAdapter;
import com.ctm.providers.car.carquote.model.request.CarQuoteRequest;
import com.ctm.providers.car.carquote.model.response.CarResponse;
import com.ctm.services.CommonQuoteService;
import com.ctm.services.Endpoint;
import com.ctm.services.ResultsService;
import com.ctm.services.SessionDataService;
import com.ctm.utils.ObjectMapperUtil;
import com.ctm.web.validation.CommencementDateValidation;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.XmlNode;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.joda.time.LocalDate;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;

import static com.ctm.model.settings.Vertical.VerticalType.CAR;
import static java.util.stream.Collectors.toList;

public class CarQuoteService extends CommonQuoteService<CarQuote, CarQuoteRequest, CarResponse> {

    private static final SessionDataService SESSION_DATA_SERVICE = new SessionDataService();

    public CarQuoteService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
    }

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

        final CarQuoteRequest carQuoteRequest = RequestAdapter.adapt(data);

        final CarResponse carResponse = sendRequest(brand, CAR, "carQuoteServiceBER", Endpoint.QUOTE, data, carQuoteRequest, CarResponse.class);

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
