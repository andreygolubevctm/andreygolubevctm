package com.ctm.web.car.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.car.model.form.CarQuote;
import com.ctm.web.car.model.form.CarRequest;
import com.ctm.web.car.model.results.CarResult;
import com.ctm.web.car.quote.model.RequestAdapter;
import com.ctm.web.car.quote.model.RequestAdapterV2;
import com.ctm.web.car.quote.model.ResponseAdapter;
import com.ctm.web.car.quote.model.ResponseAdapterV2;
import com.ctm.web.car.quote.model.request.CarQuoteRequest;
import com.ctm.web.car.quote.model.response.CarResponse;
import com.ctm.web.car.quote.model.response.CarResponseV2;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.SessionException;
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
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.validation.CommencementDateValidation;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.CAR;
import static java.util.stream.Collectors.toList;

@Component
public class CarQuoteService extends CommonRequestServiceV2 {

    private SessionDataServiceBean sessionDataServiceBean;

    @Autowired
    private Client<Request<CarQuoteRequest>, CarResponse> clientQuotes;

    @Autowired
    private Client<AggregateOutgoingRequest<CarQuoteRequest>, CarResponseV2> clientQuotesV2;

    @Autowired
    public CarQuoteService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean,
                           SessionDataServiceBean sessionDataServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
        this.sessionDataServiceBean = sessionDataServiceBean;
    }

    public List<CarResult> getQuotes(Brand brand, CarRequest data) throws Exception {

        CarQuote quote = data.getQuote();

        setFilter(quote.getFilter());

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

        final QuoteServiceProperties properties = getQuoteServiceProperties("carQuoteServiceBER", brand, CAR.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        final List<CarResult> carResults;
        if (properties.getServiceUrl().contains("-v2/") || properties.getServiceUrl().startsWith("http://localhost")) {
            final CarQuoteRequest carQuoteRequest = RequestAdapterV2.adapt(data);

            final AggregateOutgoingRequest<CarQuoteRequest> request = AggregateOutgoingRequest.<CarQuoteRequest>build()
                    .transactionId(data.getTransactionId())
                    .brandCode(brand.getCode())
                    .requestAt(data.getRequestAt())
                    .providerFilter(quote.getFilter().getProviders())
                    .payload(carQuoteRequest)
                    .build();


            final CarResponseV2 homeResponse = clientQuotesV2.post(RestSettings.<AggregateOutgoingRequest<CarQuoteRequest>>builder()
                    .request(request)
                    .jsonHeaders()
                    .url(properties.getServiceUrl() + "/quote")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(CarResponseV2.class)
                    .build())
                    .single().toBlocking().single();

            carResults = ResponseAdapterV2.adapt(homeResponse);
        } else {

            final CarQuoteRequest carQuoteRequest = RequestAdapter.adapt(data);

            Request<CarQuoteRequest> request = new Request<>();
            request.setTransactionId(data.getTransactionId());
            request.setBrandCode(brand.getCode());
            request.setRequestAt(data.getRequestAt());
            request.setClientIp(data.getClientIpAddress());
            request.setPayload(carQuoteRequest);

            final CarResponse homeResponse = clientQuotes.post(RestSettings.<Request<CarQuoteRequest>>builder()
                    .request(request)
                    .jsonHeaders()
                    .url(properties.getServiceUrl() + "/quote")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(CarResponse.class)
                    .build())
                    .single().toBlocking().single();

            carResults = ResponseAdapter.adapt(homeResponse);
        }

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
                .map(result -> {
                            result.setLeadfeedinfo(leadFeedInfo);
                            return new ResultPropertiesBuilder(request.getTransactionId(),
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
                                    .getResultProperties();
                        }
                ).flatMap(Collection::stream)
                .collect(toList());
    }

    public void writeTempResultDetails(HttpServletRequest request, CarRequest data, List<CarResult> quotes) throws SessionException, DaoException {

        Data dataBucket = sessionDataServiceBean.getDataForTransactionId(request, data.getTransactionId().toString(), true);

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