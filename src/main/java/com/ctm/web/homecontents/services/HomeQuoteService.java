package com.ctm.web.homecontents.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.exceptions.SessionExpiredException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.AggregateOutgoingRequest;
import com.ctm.web.core.results.ResultPropertiesBuilder;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.ResultsService;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.services.SessionDataServiceBean;
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
import com.ctm.web.homecontents.providers.model.request.MoreInfoRequest;
import com.ctm.web.homecontents.providers.model.response.HomeResponse;
import com.ctm.web.homecontents.providers.model.response.MoreInfo;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import rx.schedulers.Schedulers;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HOME;
import static java.util.Arrays.asList;
import static java.util.stream.Collectors.toList;
import static org.apache.commons.lang3.StringUtils.EMPTY;

@Component
public class HomeQuoteService extends CommonRequestServiceV2 {
    public static final List<String> HOLLARD_PROVIDERS = asList("REIN", "WOOL");

    private SessionDataServiceBean sessionDataServiceBean;

    @Autowired
    private Client<AggregateOutgoingRequest<HomeQuoteRequest>, HomeResponse> clientQuotes;

    @Autowired
    private Client<MoreInfoRequest, MoreInfo> clientMoreInfo;

    @Autowired
    public HomeQuoteService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean,
                            SessionDataServiceBean sessionDataServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
        this.sessionDataServiceBean = sessionDataServiceBean;
    }

    public List<HomeResult> getQuotes(Brand brand, HomeRequest data) throws Exception {

        HomeQuote quote = data.getQuote();

        setFilter(quote.getFilter());

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

        final AggregateOutgoingRequest<HomeQuoteRequest> request = AggregateOutgoingRequest.<HomeQuoteRequest>build()
                .transactionId(data.getTransactionId())
                .brandCode(brand.getCode())
                .requestAt(data.getRequestAt())
                .providerFilter(quote.getFilter().getProviders())
                .payload(homeQuoteRequest)
                .build();

        final QuoteServiceProperties properties = getQuoteServiceProperties("homeQuoteServiceBER", brand, HOME.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        final HomeResponse homeResponse = clientQuotes.post(RestSettings.<AggregateOutgoingRequest<HomeQuoteRequest>>builder()
                .request(request)
                .jsonHeaders()
                .url(properties.getServiceUrl()+"/quote")
                .timeout(properties.getTimeout())
                .responseType(MediaType.APPLICATION_JSON)
                .response(HomeResponse.class)
                .build())
                .doOnError(this::logHttpClientError)
                .observeOn(Schedulers.io()).toBlocking().single();

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
                            .addResult("discountOffer", result.getDiscountOffer())
                            .addResult("telNo", result.getContact().getPhoneNumber())
                            .addResult("openingHours", result.getContact().getCallCentreHours())
                            .addResult("leadNo", result.getQuoteNumber())
                            .addResult("brandCode", result.getBrandCode())
                            .getResultProperties();})
                .flatMap(Collection::stream)
                .collect(toList());
    }

    public HomeMoreInfo getMoreInfo(Brand brand, MoreInfoRequest moreInfoRequest, Optional<LocalDateTime> requestAt, Optional<String> environmentOverride) throws Exception {

        QuoteServiceProperties properties = getQuoteServiceProperties("homeQuoteServiceBER", brand, HOME.getCode(), environmentOverride);

        final MoreInfoRequest request = RequestAdapter.adapt(brand, moreInfoRequest, requestAt);

        final MoreInfo moreInfoResponse = clientMoreInfo.post(RestSettings.<MoreInfoRequest>builder()
                .request(request)
                .jsonHeaders()
                .url(properties.getServiceUrl()+"/data/moreInfo")
                .timeout(properties.getTimeout())
                .responseType(MediaType.APPLICATION_JSON)
                .response(MoreInfo.class)
                .build())
//                TODO: what to do on error
//                .doOnError(t -> t.printStackTrace())
                .observeOn(Schedulers.io()).toBlocking().single();

        return ResponseAdapter.adapt(moreInfoResponse);
    }

    public void writeTempResultDetails(HttpServletRequest request, HomeRequest data, List<HomeResult> quotes) throws SessionException, SessionExpiredException, DaoException {

        Data dataBucket = sessionDataServiceBean.getDataForTransactionId(request, data.getTransactionId().toString(), true);

        final String transactionId = dataBucket.getString("current/transactionId");
        if(transactionId != null){
            data.setTransactionId(Long.parseLong(transactionId));

            XmlNode resultDetails = new XmlNode("tempResultDetails");
            dataBucket.addChild(resultDetails);
            XmlNode results = new XmlNode("results");
            resultDetails.addChild(results);

            quotes.stream()
                    .filter(row -> AvailableType.Y.equals(row.getAvailable()))
                    .filter(row -> row.getPrice().isAnnualAvailable())
                    .forEach(row -> {
                                String productId = row.getProductId();
                                BigDecimal premium = row.getPrice().getAnnualPremium().setScale(0, BigDecimal.ROUND_CEILING);
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
