package com.ctm.web.health.router;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.dao.GeneralDao;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.resultsData.NoResults;
import com.ctm.web.core.model.resultsData.NoResultsObj;
import com.ctm.web.core.model.resultsData.PricesObj;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.tracking.TrackingKeyService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.ctm.web.health.model.results.InfoHealth;
import com.ctm.web.health.quote.model.ResponseAdapterModel;
import com.ctm.web.health.services.HealthQuoteEndpointService;
import com.ctm.web.health.services.HealthQuoteService;
import com.ctm.web.health.services.HealthSelectedProductService;
import io.swagger.annotations.Api;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.ws.rs.FormParam;
import javax.ws.rs.core.Context;
import java.util.Collections;
import java.util.Date;
import java.util.Map;

@Api(basePath = "/rest/health", value = "Health Quote")
@RestController
@RequestMapping("/rest/health")
public class HealthQuoteController extends CommonQuoteRouter {

    private Vertical.VerticalType verticalType = Vertical.VerticalType.HEALTH;

    private HealthQuoteService healthQuoteService;

    private ContentService contentService;

    @Autowired
    public HealthQuoteController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler,
                                 ContentService contentService, HealthQuoteService healthQuoteService) {
        super(sessionDataServiceBean, ipAddressHandler);
        this.contentService = contentService;
        this.healthQuoteService = healthQuoteService;
    }

    // call by rest/health/dropdown/list.json?type=X
    @RequestMapping(value = "/dropdown/list.json",
            method= RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String,String> getContent(@RequestParam("type") String type) {
        final Map<String,String> result;
        GeneralDao generalDao = new GeneralDao();
        result = generalDao.getValuesOrdered(type);
        return result;
    }

    @RequestMapping(value = "/quote/get.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResultsWrapper getHealthQuote(@Valid final HealthRequest data, HttpServletRequest request) throws Exception {

        // Initialise request
        Brand brand = initRouter(request);
        updateTransactionIdAndClientIP(request, data);
        updateApplicationDate(request, data);
        HealthQuoteEndpointService healthQuoteTokenService = new HealthQuoteEndpointService(ipAddressHandler);
        boolean isCallCentre = SessionUtils.isCallCentre(request.getSession());
        try{
            validateRequest(request, verticalType, brand, healthQuoteTokenService, data, isCallCentre);
        } catch(RouterException re) {
            if(re.getValidationErrors() == null){
                throw re;
            }
            return healthQuoteTokenService.createResultsWrapper(request, data.getTransactionId(), handleException(re));
        }

        InfoHealth info = new InfoHealth();
        info.setTransactionId(data.getTransactionId());

        final HealthQuote quote = data.getQuote();


        boolean isShowAll = StringUtils.equals(quote.getShowAll(), "Y");

        final Date serverDate = ApplicationService.getApplicationDate(request);
        final PageSettings pageSettings = getPageSettingsByCode(brand, verticalType);
        final Content alternatePricingActive;
        final Content payYourRateRise;
        if (isCallCentre) {
            alternatePricingActive = contentService
                    .getContent("simplesDPActive", pageSettings.getBrandId(), pageSettings.getVertical().getId(), serverDate, true);
            payYourRateRise = contentService
                    .getContent("simplesPyrrActive", pageSettings.getBrandId(), pageSettings.getVertical().getId(), serverDate, false);
        } else {
            alternatePricingActive = contentService
                    .getContent("onlineDPActive", pageSettings.getBrandId(), pageSettings.getVertical().getId(), serverDate, true);
            payYourRateRise = contentService
                    .getContent("onlinePyrrActive", pageSettings.getBrandId(), pageSettings.getVertical().getId(), serverDate, false);
        }

        final boolean competitionEnabled = StringUtils.equalsIgnoreCase(contentService.getContentValueNonStatic(request, "competitionEnabled"), "Y");

        final ResponseAdapterModel quotes = healthQuoteService.getQuotes(brand, data, alternatePricingActive, isCallCentre, payYourRateRise);

        if (quotes.getResults().isEmpty()) {
            return handleEmptyResults(request, data, healthQuoteTokenService, info);
        } else {

            String trackingKey = TrackingKeyService.generate(request, data.getTransactionId());
            info.setTrackingKey(trackingKey);

            Data dataBucket = getDataBucket(request, data.getTransactionId());
            healthQuoteService.healthCompetitionEntry(request, data, quote, competitionEnabled, dataBucket);

            PricesObj<HealthQuoteResult> results = new PricesObj<>();
            results.setResult(quotes.getResults());
            results.setInfo(info);

            quotes.getPremiumRange().ifPresent(info::setPremiumRange);
            info.setPricesHaveChanged(quotes.isHasPriceChanged());

            if (!isShowAll) {
                HealthSelectedProductService selectedProductService = new HealthSelectedProductService(
                        data.getTransactionId(),
                        ObjectMapperUtil.getObjectMapper().writeValueAsString(results)
                );
            }

            // create resultsWrapper with the token
            return healthQuoteTokenService.createResultsWrapper(request, data.getTransactionId(), results);
        }
    }

    protected ResultsWrapper handleEmptyResults(HttpServletRequest request, @FormParam("") @Valid HealthRequest data, HealthQuoteEndpointService healthQuoteTokenService, InfoHealth info) {
        NoResultsObj results = new NoResultsObj();

        NoResults noResults = new NoResults();
        noResults.setAvailable(AvailableType.N);
        noResults.setProductId("PHIO-*NONE");
        noResults.setServiceName("PHIO");

        results.setInfo(info);
        results.setResult(Collections.singletonList(noResults));

        // create resultsWrapper with the token
        return healthQuoteTokenService.createResultsWrapper(request, data.getTransactionId(), results);
    }

    private void validateRequest(@Context HttpServletRequest httpServletRequest,
                                 Vertical.VerticalType vertical,
                                 Brand brand,
                                 HealthQuoteEndpointService healthQuoteEndpointService,
                                 HealthRequest request, boolean isCallCentre) {
        healthQuoteEndpointService.init(httpServletRequest, getPageSettingsByCode(brand, vertical), request, isCallCentre);

        // throw an exception when invalid token
        if (!healthQuoteEndpointService.isValidToken()) {
            throw new RouterException("Invalid token");
        }
        if (!healthQuoteEndpointService.isValidRequest()) {
            throw new RouterException(request.getTransactionId(), healthQuoteEndpointService.getValidationErrors());
        }
    }

}