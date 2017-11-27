package com.ctm.web.car.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.car.model.form.CarQuote;
import com.ctm.web.car.model.form.CarRequest;
import com.ctm.web.car.model.request.propensityscore.CarQuotePropensityScoreRequest;
import com.ctm.web.car.model.request.propensityscore.DataRobotCarQuotePropensityScoreResponse;
import com.ctm.web.car.model.request.propensityscore.DeviceType;
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
import com.ctm.web.core.model.formData.YesNo;
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
import com.ctm.web.simples.services.TransactionDetailService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.Validate;
import org.joda.time.LocalDate;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import rx.schedulers.Schedulers;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.net.URI;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.CAR;
import static java.util.stream.Collectors.toList;
import static org.elasticsearch.common.netty.handler.codec.http.HttpHeaders.Values.NO_CACHE;

@Component
public class CarQuoteService extends CommonRequestServiceV2 {

    private static final Logger LOGGER = LoggerFactory.getLogger(CarQuoteService.class);
    private static final String PROPENSITY_SCORE = "PropensityScore";
    private static final String DATA_ROBOT_KEY = "datarobot-key";
    private static final String BUDD_PRODUCT_ID_PREFIX = "BUDD";
    public static final String QUOTE_CONTACT_PHONE = "quote/contact/phone";
    public static final String QUOTE_CONTACT_PHONEINPUT = "quote/contact/phoneinput";
    public static final String DD_MM_YYYY = "dd/MM/yyyy";
    public static final String QUOTE_OPTIONS_COMMENCEMENT_DATE = "quote/options/commencementDate";
    public static final String QUOTE_CONTACT_EMAIL = "quote/contact/email";
    public static final String QUOTE_DRIVERS_REGULAR_DOB = "quote/drivers/regular/dob";
    public static final String QUOTE_CLIENT_USER_AGENT = "quote/clientUserAgent";
    public static final String QUOTE_DRIVERS_REGULAR_CLAIMS = "quote/drivers/regular/claims";
    public static final String QUOTE_DRIVERS_REGULAR_NCD = "quote/drivers/regular/ncd";
    public static final String QUOTE_DRIVERS_REGULAR_EMPLOYMENT_STATUS = "quote/drivers/regular/employmentStatus";
    public static final String QUOTE_RISK_ADDRESS_STATE = "quote/riskAddress/state";
    public static final String QUOTE_VEHICLE_BODY = "quote/vehicle/body";
    public static final String QUOTE_VEHICLE_COLOUR = "quote/vehicle/colour";
    public static final String QUOTE_VEHICLE_FINANCE = "quote/vehicle/finance";
    public static final String QUOTE_VEHICLE_ANNUAL_KILOMETRES = "quote/vehicle/annualKilometres";
    public static final String QUOTE_VEHICLE_USE = "quote/vehicle/use";
    public static final String QUOTE_VEHICLE_MARKET_VALUE = "quote/vehicle/marketValue";
    public static final String QUOTE_VEHICLE_FACTORY_OPTIONS = "quote/vehicle/factoryOptions";
    public static final String QUOTE_VEHICLE_MAKE_DES = "quote/vehicle/makeDes";
    public static final String QUOTE_VEHICLE_DAMAGE = "quote/vehicle/damage";

    private SessionDataServiceBean sessionDataServiceBean;
    private TransactionDetailService transactionDetailService;

    @Autowired
    private Client<Request<CarQuoteRequest>, CarResponse> clientQuotes;
    @Autowired
    private Client<AggregateOutgoingRequest<CarQuoteRequest>, CarResponseV2> clientQuotesV2;
    @Autowired
    private RestTemplate restTemplate;
    @Value("${data.robot.url}")
    private String dataRobotUrl;
    @Value("${data.robot.key}")
    private String dataRobotKey;
    @Value("${data.robot.authorization.token}")
    private String dataRobotAuthorizationToken;

    @Autowired
    public CarQuoteService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean,
                           SessionDataServiceBean sessionDataServiceBean, TransactionDetailService transactionDetailService, RestTemplate restTemplate) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
        this.sessionDataServiceBean = sessionDataServiceBean;
        this.transactionDetailService = transactionDetailService;
        this.restTemplate = restTemplate;
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
        if (properties.getServiceUrl().matches(".*://.*/car-quote-v2.*") || properties.getServiceUrl().startsWith("http://localhost")) {
            LOGGER.info("Calling car-quote v2");

            final CarQuoteRequest carQuoteRequest = RequestAdapterV2.adapt(data);

            final AggregateOutgoingRequest<CarQuoteRequest> request = AggregateOutgoingRequest.<CarQuoteRequest>build()
                    .transactionId(data.getTransactionId())
                    .brandCode(brand.getCode())
                    .requestAt(data.getRequestAt())
                    .providerFilter(quote.getFilter().getProviders())
                    .payload(carQuoteRequest)
                    .build();


            final CarResponseV2 carResponse = clientQuotesV2.post(RestSettings.<AggregateOutgoingRequest<CarQuoteRequest>>builder()
                    .request(request)
                    .jsonHeaders()
                    .url(properties.getServiceUrl() + "/quote")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(CarResponseV2.class)
                    .build())
                    .doOnError(this::logHttpClientError)
                    .observeOn(Schedulers.io()).toBlocking().single();

            carResults = ResponseAdapterV2.adapt(carResponse);
        } else {
            LOGGER.info("Calling car-quote v1");

            final CarQuoteRequest carQuoteRequest = RequestAdapter.adapt(data);

            Request<CarQuoteRequest> request = new Request<>();
            request.setTransactionId(data.getTransactionId());
            request.setBrandCode(brand.getCode());
            request.setRequestAt(data.getRequestAt());
            request.setClientIp(data.getClientIpAddress());
            request.setPayload(carQuoteRequest);

            final CarResponse carResponse = clientQuotes.post(RestSettings.<Request<CarQuoteRequest>>builder()
                    .request(request)
                    .jsonHeaders()
                    .url(properties.getServiceUrl() + "/quote")
                    .timeout(properties.getTimeout())
                    .responseType(MediaType.APPLICATION_JSON)
                    .response(CarResponse.class)
                    .build())
                    .doOnError(this::logHttpClientError)
                    .observeOn(Schedulers.io()).toBlocking().single();

            carResults = ResponseAdapter.adapt(carResponse);
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
                            final String followupIntended = Optional.ofNullable(result.getFollowupIntended())
                                    .orElse("");
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
                                    .addResult("discountOffer", result.getDiscountOffer())
                                    .addResult("telNo", result.getContact().getPhoneNumber())
                                    .addResult("openingHours", result.getContact().getCallCentreHours())
                                    .addResult("leadNo", result.getQuoteNumber())
                                    .addResult("brandCode", result.getBrandCode())
                                    .addResult("followupIntended", followupIntended)
                                    .getResultProperties();
                        }
                ).flatMap(Collection::stream)
                .collect(toList());
    }

    public void writeTempResultDetails(HttpServletRequest request, CarRequest data, List<CarResult> quotes) throws SessionException, DaoException {

        Data dataBucket = sessionDataServiceBean.getDataForTransactionId(request, data.getTransactionId().toString(), true);

        final String transactionId = dataBucket.getString("current/transactionId");
        if (transactionId != null) {
            data.setTransactionId(Long.parseLong(transactionId));

            XmlNode resultDetails = new XmlNode("tempResultDetails");
            dataBucket.addChild(resultDetails);
            XmlNode results = new XmlNode("results");
            resultDetails.addChild(results);

            quotes.stream()
                    .filter(row -> row.getAvailable().equals(AvailableType.Y))
                    .forEach(row -> {
                                String productId = row.getProductId();
                                BigDecimal premium = row.getPrice().getAnnualPremium().setScale(0, BigDecimal.ROUND_CEILING);
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

    /**
     * retrieve, and store propensity score for BUDD (Budget Direct) for given transaction.
     * <p>
     * <pre>
     * Notes:
     *  - front end sends product ids which are ranked based on `rankBy` criteria e.g., price.annual-asc.
     *  - 'DUPLICATE' value in db.`result_properties` if try to insert value for same composite primary key.
     *  - Woolworths have duplicate `product_code` e.g., WOOL-01-01 represent multiple products on car quote results.
     *  - Only stores propensity score for BUDD as Data Robot is only designed for BUDD. lead service would have to be
     *      configured the same, and only look for propensity score for BUDD only.
     *  - if user edits the journey, there will be new transactionId, hence don't need to worry about duplicate
     *      `result_properties` for given transaction.
     * </pre>
     *
     * @param productIdsOrderedByRank
     * @param transactionId
     */
    public void retrieveAndStoreCarQuotePropensityScore(final List<String> productIdsOrderedByRank, final Long transactionId) {
        LOGGER.info("Received request for get propensity score for transactionId: {}", transactionId);
        final List<ResultProperty> resultProperties = buildResultPropertiesWithPropensityScore(productIdsOrderedByRank, transactionId);
        savePropensityScoreAsResultProperties(transactionId, resultProperties);
    }

    /**
     * build `result_propensity` with propensity score to be stored in the database.
     *
     * @param productIdsOrderedByRank
     * @param transactionId
     * @return list of result_property
     */
    protected List<ResultProperty> buildResultPropertiesWithPropensityScore(List<String> productIdsOrderedByRank, Long transactionId) {
        final List<ResultProperty> resultProperties = new ArrayList<>();

        //Data Robot is designed only for BUDD (Budget Direct)
        productIdsOrderedByRank
                .stream()
                .filter(productId -> productId.contains(BUDD_PRODUCT_ID_PREFIX))
                .collect(Collectors.toList())
                .forEach(filteredProductId -> {

                    //front end sends rank by position in list. This won't work if we have duplicate productIds.
                    //Currently only woolworths have duplicate product_code hence this won't affect BUDD data robot call.
                    final Integer productRank = productIdsOrderedByRank.indexOf(filteredProductId);

                    //get propensity score from Data Robot
                    final String propensityScore = getPropensityScoreFromDataRobot(buildQuotePropensityScoreRequest(productRank, transactionId));
                    final ResultProperty resultProperty = new ResultProperty();
                    resultProperty.setProductId(filteredProductId);
                    resultProperty.setTransactionId(transactionId);
                    resultProperty.setProperty(PROPENSITY_SCORE);
                    resultProperty.setValue(propensityScore);
                    resultProperties.add(resultProperty);
                });
        return resultProperties;
    }

    /**
     * store `result_property` to db.
     * <p>
     * Note: Unable to @Mock this because mockito doesn't support static mocks.
     *
     * @param transactionId
     * @param resultProperties
     */
    private void savePropensityScoreAsResultProperties(final Long transactionId, final List<ResultProperty> resultProperties) {
        //Save propensity score to db.
        try {
            ResultsService.saveResultsProperties(resultProperties);
        } catch (Exception e) {
            LOGGER.error("Unable to save Data Robot car quote propensity score for transaction: " + transactionId, e);
        }
    }

    /**
     * call Data Robot api to get propensity score.
     *
     * @param carQuotePropensityScoreRequest
     * @return propensity score
     */
    private String getPropensityScoreFromDataRobot(CarQuotePropensityScoreRequest carQuotePropensityScoreRequest) {
        LOGGER.info("Sending request to Data Robot {}", getJsonString(carQuotePropensityScoreRequest));

        final HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        headers.set(HttpHeaders.AUTHORIZATION, dataRobotAuthorizationToken);
        headers.setCacheControl(NO_CACHE);
        headers.set(DATA_ROBOT_KEY, dataRobotKey);

        final HttpEntity<List<CarQuotePropensityScoreRequest>> entity = new HttpEntity(Arrays.asList(carQuotePropensityScoreRequest), headers);
        final ResponseEntity<DataRobotCarQuotePropensityScoreResponse> responseEntity = restTemplate.postForEntity(URI.create(dataRobotUrl), entity, DataRobotCarQuotePropensityScoreResponse.class);

        //get propensity score from data robot response, ready to be stored in `result_property` table.
        return Optional.ofNullable(responseEntity.getBody()).map(response -> {
            if (!response.getPredictions().isEmpty() && response.getPredictions().iterator().hasNext()) {
                LOGGER.info("Data robot car quote propensity score response: {}", getJsonString(response));
                return Double.toString(response.getPredictions().iterator().next().getClassProbabilities().getOne());
            }
            LOGGER.error("Invalid or null Data robot car quote propensity score response: {}. Setting propensity score to null", new JSONObject(response).toString());
            throw new IllegalStateException("Invalid or empty propensity score value returned by Data Robot");
        }).orElseThrow(() -> {
            LOGGER.error("Invalid or empty response from Data Robot");
            return new IllegalStateException("Invalid or empty response from Data Robot");
        });
    }

    /**
     * get `transaction_details` from db, and create a request to be send to Data Robot.
     *
     * @param rankPosition
     * @param transactionId
     * @return request to be send to data robot.
     */
    private CarQuotePropensityScoreRequest buildQuotePropensityScoreRequest(int rankPosition, Long transactionId) {

        //get `transaction_detail` from db for transaction id, contains person, vehicle data.
        Data transactionDetailsInXmlData = null;
        try {
            transactionDetailsInXmlData = this.transactionDetailService.getTransactionDetailsInXmlData(transactionId);
        } catch (DaoException e) {
            throw new IllegalStateException("Exception while trying to load transaction details for transaction id: " + transactionId, e);
        }

        if (transactionDetailsInXmlData == null || transactionDetailsInXmlData.isEmpty()) {
            throw new IllegalStateException("Expected non null or empty transaction_details for transactionId: " + transactionId);
        }

        // Build the request to be send to Data Robot
        final CarQuotePropensityScoreRequest carQuotePropensityScoreRequest = new CarQuotePropensityScoreRequest();
        carQuotePropensityScoreRequest.setRankPosition(rankPosition);
        carQuotePropensityScoreRequest.setPhoneFlag(buildPhoneFlag(transactionDetailsInXmlData.getString(QUOTE_CONTACT_PHONE), transactionDetailsInXmlData.getString(QUOTE_CONTACT_PHONEINPUT)));
        carQuotePropensityScoreRequest.setCommencementDays(daysBetween(java.time.LocalDate.now(), transactionDetailsInXmlData.getString(QUOTE_OPTIONS_COMMENCEMENT_DATE)));
        carQuotePropensityScoreRequest.setEmailFlag(buildEmailFlag(transactionDetailsInXmlData.getString(QUOTE_CONTACT_EMAIL)));
        carQuotePropensityScoreRequest.setAge(buildAge(java.time.LocalDate.now(), transactionDetailsInXmlData.getString(QUOTE_DRIVERS_REGULAR_DOB)));
        carQuotePropensityScoreRequest.setDeviceType(DeviceType.getDeviceType(transactionDetailsInXmlData.getString(QUOTE_CLIENT_USER_AGENT)));
        carQuotePropensityScoreRequest.setHourCompleted(java.time.LocalTime.now().getHour());
        carQuotePropensityScoreRequest.setDriverRegularClaims(transactionDetailsInXmlData.getString(QUOTE_DRIVERS_REGULAR_CLAIMS));
        carQuotePropensityScoreRequest.setDriverRegularNcd(transactionDetailsInXmlData.getString(QUOTE_DRIVERS_REGULAR_NCD));
        carQuotePropensityScoreRequest.setDriverRegularEmploymentStatus(transactionDetailsInXmlData.getString(QUOTE_DRIVERS_REGULAR_EMPLOYMENT_STATUS));
        carQuotePropensityScoreRequest.setRiskAddressState(transactionDetailsInXmlData.getString(QUOTE_RISK_ADDRESS_STATE));
        carQuotePropensityScoreRequest.setVehicleBody(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_BODY));
        carQuotePropensityScoreRequest.setVehicleColour(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_COLOUR));
        carQuotePropensityScoreRequest.setVehicleFinance(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_FINANCE));
        carQuotePropensityScoreRequest.setVehicleAnnualKilometers(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_ANNUAL_KILOMETRES));
        carQuotePropensityScoreRequest.setVehicleUse(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_USE));
        carQuotePropensityScoreRequest.setVehicleMarketValue(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_MARKET_VALUE));
        carQuotePropensityScoreRequest.setVehicleFactoryOptions(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_FACTORY_OPTIONS));
        carQuotePropensityScoreRequest.setVehicleMakeDescription(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_MAKE_DES));
        carQuotePropensityScoreRequest.setVehicleDamage(transactionDetailsInXmlData.getString(QUOTE_VEHICLE_DAMAGE));

        return carQuotePropensityScoreRequest;
    }

    /**
     * returns json string of given object.
     *
     * @param obj
     * @return json string
     */
    private String getJsonString(final Object obj) {
        try {
            return new ObjectMapper().writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * returns years between fromDate, and toDate.
     *
     * @param fromDate
     * @param toDate
     * @return years between fromDate, and toDate
     */
    protected Long buildAge(final java.time.LocalDate fromDate, final String toDate) {
        Validate.notBlank(toDate);

        final java.time.LocalDate driverDob = java.time.LocalDate.parse(toDate, DateTimeFormatter.ofPattern(DD_MM_YYYY));
        return ChronoUnit.YEARS.between(driverDob, fromDate);
    }

    /**
     * returns flag if given email is not blank.
     *
     * @param email string
     * @return email flag
     */
    protected YesNo buildEmailFlag(final String email) {
        return StringUtils.isNotBlank(email) ? YesNo.Y : YesNo.N;
    }

    /**
     * returns number of days between fromDate, and toDate
     * <p>
     * Note: uses system default timezone
     *
     * @param fromDate
     * @param toDate
     * @return days between fromDate, and toDate
     */
    protected Long daysBetween(java.time.LocalDate fromDate, final String toDate) {
        Validate.notBlank(toDate, "toDate can't be null");

        final java.time.LocalDate commencementDate = java.time.LocalDate.parse(toDate, DateTimeFormatter.ofPattern(DD_MM_YYYY));
        return ChronoUnit.DAYS.between(commencementDate, fromDate);
    }

    /**
     * returns flag if given phone, or phoneInput is not blank.
     * <p>
     * Note: uses system default timezone
     *
     * @param phone
     * @param phoneInput
     * @return Y if phone or phoneInput is not blank, else N
     */
    protected YesNo buildPhoneFlag(final String phone, final String phoneInput) {
        YesNo phoneFlag = YesNo.N;
        if (StringUtils.isNotBlank(phone) || StringUtils.isNotBlank(phoneInput)) {
            phoneFlag = YesNo.Y;
        }
        return phoneFlag;
    }
}
