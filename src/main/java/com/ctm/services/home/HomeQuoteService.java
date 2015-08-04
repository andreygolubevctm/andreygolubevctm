package com.ctm.services.home;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.exceptions.ServiceException;
import com.ctm.model.home.form.HomeQuote;
import com.ctm.model.home.form.HomeRequest;
import com.ctm.model.home.results.HomeResult;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.model.settings.*;
import com.ctm.providers.Request;
import com.ctm.providers.ResultPropertiesBuilder;
import com.ctm.providers.home.homequote.model.RequestAdapter;
import com.ctm.providers.home.homequote.model.ResponseAdapter;
import com.ctm.providers.home.homequote.model.request.HomeQuoteRequest;
import com.ctm.providers.home.homequote.model.response.HomeResponse;
import com.ctm.services.ResultsService;
import com.ctm.services.ServiceConfigurationService;
import com.ctm.utils.ObjectMapperUtil;
import com.ctm.web.validation.CommencementDateValidation;
import com.ctm.xml.XMLOutputWriter;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.xml.XMLOutputWriter.REQ_OUT;

public class HomeQuoteService {

    private static final Logger logger = Logger.getLogger(HomeQuoteService.class);

    public static final String SERVICE_URL = "serviceUrl";
    public static final String TIMEOUT_MILLIS = "timeoutMillis";
    public static final String DEBUG_PATH = "debugPath";

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

        // Get URL of home-quote service
        String serviceUrl = null;
        String debugPath = null;
        int timeout = 30;
        try {
            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("homeQuoteServiceBER", brand.getVerticalByCode(Vertical.VerticalType.HOME.getCode()).getId(), brand.getId());
            serviceUrl = serviceConfig.getPropertyValueByKey(SERVICE_URL, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
            debugPath = serviceConfig.getPropertyValueByKey(DEBUG_PATH, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
            timeout = Integer.parseInt(serviceConfig.getPropertyValueByKey(TIMEOUT_MILLIS, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE));
        }catch (DaoException | ServiceConfigurationException e ){
            throw new ServiceException("HomeQuote config error", e);
        }

        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_HOME-QUOTE" , debugPath);
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(timeout);
            connection.setReadTimeout(timeout);
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = connection.get(serviceUrl+"/quote");
            HomeResponse homeResponse = objectMapper.readValue(response, HomeResponse.class);

            // Log response
            writer.lastWriteXmlToFile(response);

            final List<HomeResult> homeResults = ResponseAdapter.adapt(homeResponse);

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
                if (result.getHomeExcess() != null) {
                    builder.addResult("HHB/excess/total", result.getHomeExcess().getAmount());
                } else {
                    builder.addResult("HHB/excess/total", "0");
                }
                if (result.getContentsExcess() != null) {
                    builder.addResult("HHC/excess/total", result.getContentsExcess().getAmount());
                } else {
                    builder.addResult("HHC/excess/total", "0");
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

}
