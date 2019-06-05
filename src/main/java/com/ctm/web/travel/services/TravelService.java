package com.ctm.web.travel.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.AggregateOutgoingRequest;
import com.ctm.web.core.providers.model.Request;
import com.ctm.web.core.results.ResultPropertiesBuilder;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.ResultsService;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.travel.model.form.TravelQuote;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.model.results.TravelResult;
import com.ctm.web.travel.quote.model.RequestAdapter;
import com.ctm.web.travel.quote.model.RequestAdapterV2;
import com.ctm.web.travel.quote.model.ResponseAdapter;
import com.ctm.web.travel.quote.model.ResponseAdapterV2;
import com.ctm.web.travel.quote.model.request.TravelQuoteRequest;
import com.ctm.web.travel.quote.model.response.TravelResponse;
import com.ctm.web.travel.quote.model.response.TravelResponseV2;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import rx.schedulers.Schedulers;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.TRAVEL;

@Component
public class TravelService extends CommonRequestServiceV2 {

    private static final Logger LOGGER = LoggerFactory.getLogger(TravelService.class);

    @Autowired
    private Client<Request<TravelQuoteRequest>, TravelResponse> clientQuotes;

    @Autowired
    private Client<AggregateOutgoingRequest<TravelQuoteRequest>, TravelResponseV2> clientQuotesV2;

    @Autowired
    private TransactionDao transactionDao;

    @Autowired
    public TravelService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
    }

    /**
     * Call travel-quote aggregation service.
     *
     * @param brand
     * @param data
     * @return
     */
    public List<TravelResult> getQuotes(Brand brand, TravelRequest data) throws Exception {

        // Get quote from Form Request
        final TravelQuote quote = data.getQuote();

        Long transactionId = data.getTransactionId(); // cannot be null
        String anonymousId = data.getAnonymousId();
        String userId = data.getUserId();
        if (anonymousId!=null||userId!=null) {
            transactionDao.writeAuthIDs(transactionId,anonymousId,userId);
        }

        setFilter(quote.getFilter());

        final QuoteServiceProperties properties = getQuoteServiceProperties("travelQuoteService", brand, TRAVEL.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        final List<TravelResult> travelResults;
        if (properties.getServiceUrl().matches(".*://.*/travel-quote-v2.*") || properties.getServiceUrl().startsWith("http://localhost")) {
            LOGGER.info("Calling travel-quote v2");

            // Convert post data from form into a Travel-quote request
            final TravelQuoteRequest travelQuoteRequest = RequestAdapterV2.adapt(data);

            final AggregateOutgoingRequest<TravelQuoteRequest> request = AggregateOutgoingRequest.<TravelQuoteRequest>build()
                    .transactionId(data.getTransactionId())
                    .brandCode(brand.getCode())
                    .requestAt(data.getRequestAt())
                    .providerFilter(quote.getFilter().getProviders())
                    .payload(travelQuoteRequest)
                    .userId(userId)
                    .anonymousId(anonymousId)
                    .build();

            final TravelResponseV2 travelResponse = clientQuotesV2.post(RestSettings.<AggregateOutgoingRequest<TravelQuoteRequest>>builder()
                    .request(request)
                    .jsonHeaders()
                    .url(properties.getServiceUrl() + "/quote")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(TravelResponseV2.class)
                    .build())
                    .doOnError(this::logHttpClientError)
                    .observeOn(Schedulers.io()).toBlocking().single();

            travelResults = ResponseAdapterV2.adapt(travelQuoteRequest, travelResponse);

        } else {
            LOGGER.info("Calling travel-quote v1");

            // Convert post data from form into a Travel-quote request
            final TravelQuoteRequest travelQuoteRequest = RequestAdapter.adapt(data);

            Request<TravelQuoteRequest> request = new Request<>();
            request.setTransactionId(data.getTransactionId());
            request.setBrandCode(brand.getCode());
            request.setRequestAt(data.getRequestAt());
            request.setClientIp(data.getClientIpAddress());
            request.setPayload(travelQuoteRequest);


            TravelResponse travelResponse = clientQuotes.post(RestSettings.<Request<TravelQuoteRequest>>builder()
                    .request(request)
                    .jsonHeaders()
                    .url(properties.getServiceUrl() + "/quote")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(TravelResponse.class)
                    .build())
                    .doOnError(this::logHttpClientError)
                    .observeOn(Schedulers.io()).toBlocking().single();

            // Convert travel-quote java model to front end model ready for JSON conversion to the front end.
            travelResults = ResponseAdapter.adapt(travelQuoteRequest, travelResponse);
        }

        String gaClientId = quote.getGaclientid();
        List<ResultProperty> resultProperties = new ArrayList<>();
        for (TravelResult result : travelResults) {
            if (AvailableType.Y.equals(result.getAvailable())) {

                ResultPropertiesBuilder builder = new ResultPropertiesBuilder(
                        data.getTransactionId(), result.getProductId());
                builder.addResult("quoteUrl", result.getQuoteUrl());
                builder.addResult("providerCode", result.getServiceName());
                builder.addResult("gaClientId", gaClientId);
                resultProperties.addAll(builder.getResultProperties());

            }
        }

        ResultsService.saveResultsProperties(resultProperties);

        return travelResults;

    }
}
