package com.ctm.web.homecontents.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.results.ResultPropertiesBuilder;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.services.CommonQuoteService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.ResultsService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.core.validation.CommencementDateValidation;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.homecontents.model.form.HomeQuote;
import com.ctm.web.homecontents.model.form.HomeRequest;
import com.ctm.web.homecontents.model.results.HomeMoreInfo;
import com.ctm.web.homecontents.model.results.HomeResult;
import com.ctm.web.homecontents.providers.model.RequestAdapter;
import com.ctm.web.homecontents.providers.model.ResponseAdapter;
import com.ctm.web.homecontents.providers.model.request.HomeQuoteRequest;
import com.ctm.web.homecontents.providers.model.response.HomeResponse;
import com.ctm.web.homecontents.providers.model.response.MoreInfo;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.joda.time.LocalDate;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HOME;
import static java.util.Arrays.asList;
import static java.util.stream.Collectors.toList;
import static org.apache.commons.lang3.StringUtils.EMPTY;

public class HomeQuoteService extends CommonQuoteService<HomeQuote, HomeQuoteRequest, HomeResponse> {
    public static final List<String> HOLLARD_PROVIDERS = asList("REIN", "WOOL");

    private static final SessionDataService SESSION_DATA_SERVICE = new SessionDataService();

    public HomeQuoteService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
    }

    public List<HomeResult> getQuotes(Brand brand, HomeRequest data) throws Exception {

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

        final HomeQuoteRequest homeQuoteRequest = RequestAdapter.adapt(data);
        HomeResponse homeResponse = sendRequest(brand, Vertical.VerticalType.HOME, "homeQuoteServiceBER", Endpoint.QUOTE, data,
                homeQuoteRequest, HomeResponse.class);

        final List<HomeResult> homeResults = ResponseAdapter.adapt(homeQuoteRequest, homeResponse);

        saveResults(data, homeResults);

        return homeResults;

    }

    private void saveResults(HomeRequest request, List<HomeResult> results) throws Exception {
        ResultsService.saveResultsProperties(getResultProperties(request, results));
    }

    private List<ResultProperty> getResultProperties(HomeRequest request, List<HomeResult> results) {
        String leadFeedInfo = request.getQuote().createLeadFeedInfo();

        LocalDate validUntil = LocalDate.now().plusDays(30);

        return results.stream()
                .filter(result -> AvailableType.Y.equals(result.getAvailable()))
                .map(result -> {
                    result.setLeadfeedinfo(leadFeedInfo);

                    return new ResultPropertiesBuilder(request.getTransactionId(),
                            result.getProductId())
                            .addResult("leadfeedinfo", leadFeedInfo)
                            .addResult("validateDate/display", EMAIL_DATE_FORMAT.print(validUntil))
                            .addResult("validateDate/normal", NORMAL_FORMAT.print(validUntil))
                            .addResult("productId", result.getProductId())
                            .addResult("productDes", result.getProviderProductName())
                            .addResult("des", HOLLARD_PROVIDERS.contains(result.getBrandCode()) ? result.getProductDescription() : EMPTY)
                            .addResult("HHB/excess/amount", result.getHomeExcess() != null ? result.getHomeExcess().getAmount() : "0")
                            .addResult("HHC/excess/amount", result.getContentsExcess() != null ? result.getContentsExcess().getAmount() : "0")
                            .addResult("headline/name", result.getProductName())
                            .addResult("quoteUrl", result.getQuoteUrl())
                            .addResult("telNo", result.getContact().getPhoneNumber())
                            .addResult("openingHours", result.getContact().getCallCentreHours())
                            .addResult("leadNo", result.getQuoteNumber())
                            .addResult("brandCode", result.getBrandCode())
                            .getResultProperties();})
                .flatMap(Collection::stream)
                .collect(toList());
    }

    public HomeMoreInfo getMoreInfo(Brand brand, String productId, String type, Optional<String> environmentOverride) throws Exception {

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties("homeQuoteServiceBER", brand, HOME.getCode(), environmentOverride);

        ObjectMapper objectMapper = ObjectMapperUtil.getObjectMapper();

        String jsonRequest = objectMapper.writeValueAsString(RequestAdapter.adapt(brand, productId, type));

        SimpleConnection connection = new SimpleConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(serviceProperties.getTimeout());
        connection.setReadTimeout(serviceProperties.getTimeout());
        connection.setContentType("application/json");
        connection.setPostBody(jsonRequest);

        final String response = connection.get(serviceProperties.getServiceUrl() + "/data/moreInfo");

        MoreInfo moreInfoResponse = objectMapper.readValue(response, MoreInfo.class);

        return ResponseAdapter.adapt(moreInfoResponse);
    }

    public void writeTempResultDetails(MessageContext context, HomeRequest data, List<HomeResult> quotes) throws SessionException, DaoException {

        Data dataBucket = SESSION_DATA_SERVICE.getDataForTransactionId(context.getHttpServletRequest(), data.getTransactionId().toString(), true);

        final String transactionId = dataBucket.getString("current/transactionId");
        if(transactionId != null){
            data.setTransactionId(Long.parseLong(transactionId));

            XmlNode resultDetails = new XmlNode("tempResultDetails");
            dataBucket.addChild(resultDetails);
            XmlNode results = new XmlNode("results");
            resultDetails.addChild(results);

            quotes.stream()
                    .filter(row -> AvailableType.Y.equals(row.getAvailable()))
                    .forEach(row -> {
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
                    );

        }

    }
}
