package com.ctm.services.car;

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
import com.ctm.services.ResultsService;
import com.ctm.services.SessionDataService;
import com.ctm.web.validation.CommencementDateValidation;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.XmlNode;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import static com.ctm.model.settings.Vertical.VerticalType.CAR;

public class CarQuoteService extends CommonQuoteService<CarQuote, CarQuoteRequest, CarResponse> {

	private static final Logger logger = LoggerFactory.getLogger(CarQuoteService.class);

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

        CarResponse carResponse = sendRequest(brand, CAR, "carQuoteServiceBER", "_CAR-QUOTE", data, carQuoteRequest, CarResponse.class);

        final List<CarResult> carResults = ResponseAdapter.adapt(carResponse);

        saveResults(data, carResults);

        return carResults;
    }

    private void saveResults(CarRequest request, List<CarResult> results) throws Exception {
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
            System.out.println(e.getMessage());
        }

    }
}
