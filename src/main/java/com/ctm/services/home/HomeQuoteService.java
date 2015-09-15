package com.ctm.services.home;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.connectivity.exception.ConnectionException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.exceptions.SessionException;
import com.ctm.logging.XMLOutputWriter;
import com.ctm.model.QuoteServiceProperties;
import com.ctm.model.home.form.HomeQuote;
import com.ctm.model.home.form.HomeRequest;
import com.ctm.model.home.results.HomeMoreInfo;
import com.ctm.model.home.results.HomeResult;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.model.settings.Brand;
import com.ctm.providers.Request;
import com.ctm.providers.ResultPropertiesBuilder;
import com.ctm.providers.home.homequote.model.RequestAdapter;
import com.ctm.providers.home.homequote.model.ResponseAdapter;
import com.ctm.providers.home.homequote.model.request.HomeQuoteRequest;
import com.ctm.providers.home.homequote.model.response.HomeResponse;
import com.ctm.providers.home.homequote.model.response.MoreInfo;
import com.ctm.services.CommonQuoteService;
import com.ctm.services.ResultsService;
import com.ctm.services.SessionDataService;
import com.ctm.utils.ObjectMapperUtil;
import com.ctm.web.validation.CommencementDateValidation;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.XmlNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

import static com.ctm.logging.XMLOutputWriter.REQ_OUT;
import static com.ctm.model.settings.Vertical.VerticalType.HOME;
import static java.util.Arrays.asList;
import static org.apache.commons.lang3.StringUtils.EMPTY;

public class HomeQuoteService extends CommonQuoteService<HomeQuote> {

    private static final Logger logger = Logger.getLogger(HomeQuoteService.class);

    public static final List<String> HOLLARD_PROVIDERS = asList("REIN", "WOOL");

    public List<HomeResult> getQuotes(Brand brand, HomeRequest data) {

        HomeQuote quote = data.getQuote();

        // Fix the commencement date if prior to the current date
        String sanitisedCommencementDate = quote.getStartDate();
        // Fix the commencement date if prior to the current date
        if (!CommencementDateValidation.isValid(quote.getStartDate(), "dd/MM/yyyy")) {
            try {
                sanitisedCommencementDate = CommencementDateValidation.getToday("dd/MM/yyyy");
            } catch (Exception e) {
                throw new RouterException(e);
            }
        }

        if (!StringUtils.equals(sanitisedCommencementDate, quote.getStartDate())) {
            quote.setStartDate(sanitisedCommencementDate);
        }


        Request request = new Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());
        final HomeQuoteRequest homeQuoteRequest = RequestAdapter.adapt(data);
        request.setPayload(homeQuoteRequest);

        ObjectMapper objectMapper = ObjectMapperUtil.getObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties("homeQuoteServiceBER", brand, HOME.getCode(), data);

        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_HOME-QUOTE" , serviceProperties.getDebugPath());
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(serviceProperties.getTimeout());
            connection.setReadTimeout(serviceProperties.getTimeout());
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = null;
            try {
                response = connection.get(serviceProperties.getServiceUrl()+"/quote");
            } catch (ConnectionException e) {
                logger.error("Exception calling get quotes.", e);
            }
            HomeResponse homeResponse = objectMapper.readValue(response, HomeResponse.class);

            // Log response
            writer.lastWriteXmlToFile(response);

            final List<HomeResult> homeResults = ResponseAdapter.adapt(homeQuoteRequest, homeResponse);

            saveResults(data, homeResults);

            return homeResults;

        }catch(IOException e){
            logger.error("Error parsing or connecting to home-quote", e);
        }

        return null;
    }

    private void saveResults(HomeRequest request, List<HomeResult> results) {
        String leadFeedInfo = request.getQuote().createLeadFeedInfo();

        LocalDate validUntil = LocalDate.now().plusDays(30);

        DateTimeFormatter emailDateFormat = DateTimeFormat.forPattern("dd MMMMM yyyy");
        DateTimeFormatter normalFormat = DateTimeFormat.forPattern("yyyy-MM-dd");

        List<ResultProperty> resultProperties = new ArrayList<>();
        for (HomeResult result : results) {
            if (AvailableType.Y.equals(result.getAvailable())) {
                result.setLeadfeedinfo(leadFeedInfo);

                ResultPropertiesBuilder builder = new ResultPropertiesBuilder(request.getTransactionId(),
                        result.getProductId());

                builder.addResult("leadfeedinfo", leadFeedInfo)
                        .addResult("validateDate/display", emailDateFormat.print(validUntil))
                        .addResult("validateDate/normal", normalFormat.print(validUntil))
                        .addResult("productId", result.getProductId())
                        .addResult("productDes", result.getProviderProductName());
                if (HOLLARD_PROVIDERS.contains(result.getBrandCode())) {
                    builder.addResult("des", result.getProductDescription());
                } else {
                    builder.addResult("des", EMPTY);
                }
                if (result.getHomeExcess() != null) {
                    builder.addResult("HHB/excess/amount", result.getHomeExcess().getAmount());
                } else {
                    builder.addResult("HHB/excess/amount", "0");
                }
                if (result.getContentsExcess() != null) {
                    builder.addResult("HHC/excess/amount", result.getContentsExcess().getAmount());
                } else {
                    builder.addResult("HHC/excess/amount", "0");
                }
                builder.addResult("headline/name", result.getProductName())
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

    public HomeMoreInfo getMoreInfo(Brand brand, String productId, String type, Optional<String> environmentOverride) {

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties("homeQuoteServiceBER", brand, HOME.getCode(), environmentOverride);

        ObjectMapper objectMapper = ObjectMapperUtil.getObjectMapper();

        try {
            String jsonRequest = objectMapper.writeValueAsString(RequestAdapter.adapt(brand, productId, type));


            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(serviceProperties.getTimeout());
            connection.setReadTimeout(serviceProperties.getTimeout());
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = null;
            try {
                response = connection.get(serviceProperties.getServiceUrl() + "/data/moreInfo");
            } catch (ConnectionException e) {
                logger.error("Exception calling get more info.", e);
            }

            MoreInfo moreInfoResponse = objectMapper.readValue(response, MoreInfo.class);

            return ResponseAdapter.adapt(moreInfoResponse);
        } catch (IOException e) {
            logger.error("Error parsing or connecting to home-quote", e);
        }
        return null;
    }

    public void writeTempResultDetails(MessageContext context, HomeRequest data, List<HomeResult> quotes) {

        SessionDataService service = new SessionDataService();
        String clientIpAddress = null;

        try {
            Data dataBucket = service.getDataForTransactionId(context.getHttpServletRequest(), data.getTransactionId().toString(), true);

            if(dataBucket != null && dataBucket.getString("current/transactionId") != null){
                data.setTransactionId(Long.parseLong(dataBucket.getString("current/transactionId")));

                XmlNode resultDetails = new XmlNode("tempResultDetails");
                dataBucket.addChild(resultDetails);
                XmlNode results = new XmlNode("results");

                Iterator<HomeResult> quotesIterator = quotes.iterator();
                while (quotesIterator.hasNext()) {
                    HomeResult row = quotesIterator.next();
                    if(row.getAvailable().equals(AvailableType.Y)) {
                        String productId = row.getProductId();
                        BigDecimal premium = row.getPrice().getAnnualPremium();
                        XmlNode product = new XmlNode(productId);
                        XmlNode price = new XmlNode("price");
                        XmlNode annual = new XmlNode("annual");
                        XmlNode total = new XmlNode("total", premium.toString());
                        annual.addChild(total);
                        price.addChild(annual);
                        product.addChild(price);
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
