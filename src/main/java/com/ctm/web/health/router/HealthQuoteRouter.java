package com.ctm.web.health.router;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.dao.GeneralDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
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
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.tracking.TrackingKeyService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.ctm.web.health.model.results.InfoHealth;
import com.ctm.web.health.model.results.PremiumRange;
import com.ctm.web.health.services.HealthQuoteEndpointService;
import com.ctm.web.health.services.HealthQuoteService;
import com.ctm.web.health.services.HealthQuoteSummaryService;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Path("/health")
public class HealthQuoteRouter extends CommonQuoteRouter<HealthRequest> {

    private final HealthQuoteService healthQuoteService = new HealthQuoteService();

    private final HealthQuoteSummaryService healthQuoteSummaryService = new HealthQuoteSummaryService();
    private final ContentService contentService;

    public HealthQuoteRouter() throws ConfigSettingException, DaoException {
        super(new SessionDataServiceBean());
        this.contentService =  ContentService.getInstance();
    }


    public HealthQuoteRouter(SessionDataServiceBean sessionDataServiceBean, ContentService contentService) {
        super(sessionDataServiceBean);
        this.contentService = contentService;
    }


    @GET
    @Path("/dropdown/list.json")
    @Produces("application/json")
    // call by rest/health/dropdown/list.json?type=X
    public Map<String,String> getContent(@QueryParam("type") String type) {
        final Map<String,String> result;
        GeneralDao generalDao = new GeneralDao();
        result = generalDao.getValuesOrdered(type);
        return result;
    }

    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getHealthQuote(@Context MessageContext context, @FormParam("") @Valid final HealthRequest data) throws Exception {

        Vertical.VerticalType vertical = HEALTH;

        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data);
        HealthQuoteEndpointService healthQuoteTokenService = new HealthQuoteEndpointService();
        boolean isCallCentre = SessionUtils.isCallCentre(context.getHttpServletRequest().getSession());
        try{
            validateRequest(context.getHttpServletRequest(), vertical, brand, healthQuoteTokenService, data, isCallCentre);
        } catch(RouterException re) {
            if(re.getValidationErrors() == null){
                throw re;
            }
            return healthQuoteTokenService.createResultsWrapper(context.getHttpServletRequest(), data.getTransactionId(), handleException(re));
        }

        InfoHealth info = new InfoHealth();
        info.setTransactionId(data.getTransactionId());

        final HealthQuote quote = data.getQuote();


        boolean isShowAll = StringUtils.equals(quote.getShowAll(), "Y");
        boolean isOnResultsPage = StringUtils.equals(quote.getOnResultsPage(), "Y");
        if (isShowAll && isOnResultsPage) {
            PremiumRange summary = healthQuoteSummaryService.getSummary(brand, data, isCallCentre);
            info.setPremiumRange(summary);
        }


        final Date serverDate = ApplicationService.getApplicationDate(context.getHttpServletRequest());
        final PageSettings pageSettings = getPageSettingsByCode(brand, vertical);
        final Content alternatePricingActive = contentService
                .getContent("alternatePricingActive", pageSettings.getBrandId(), pageSettings.getVertical().getId(), serverDate, true);
        final boolean competitionEnabled = StringUtils.equalsIgnoreCase(contentService.getContentValueNonStatic(context.getHttpServletRequest(), "competitionEnabled"), "Y");

        final Pair<Boolean, List<HealthQuoteResult>> quotes = healthQuoteService.getQuotes(brand, data, alternatePricingActive, isCallCentre);

        if (quotes.getValue().isEmpty()) {
            return handleEmptyResults(context, data, healthQuoteTokenService, info);
        } else {

            String trackingKey = TrackingKeyService.generate(
                    context.getHttpServletRequest(), data.getTransactionId());
            info.setTrackingKey(trackingKey);

            Data dataBucket = getDataBucket(context, data.getTransactionId());
            healthQuoteService.healthCompetitionEntry(context, data, quote, competitionEnabled, dataBucket);

            PricesObj<HealthQuoteResult> results = new PricesObj<>();
            results.setResult(quotes.getRight());
            results.setInfo(info);
            info.setPricesHaveChanged(quotes.getLeft());

            if (!isShowAll) {

                if (dataBucket.hasChild("confirmation")) {
                    dataBucket.removeChild("confirmation");
                }

                XmlNode confirmation = new XmlNode("confirmation");
                dataBucket.addChild(confirmation);
                XmlNode details = new XmlNode("health");
                confirmation.addChild(details);

                details.setText("<![CDATA[" + ObjectMapperUtil.getObjectMapper().writeValueAsString(results) + "]]>");
            }

            // create resultsWrapper with the token
            return healthQuoteTokenService.createResultsWrapper(context.getHttpServletRequest(), data.getTransactionId(), results);
        }
    }

    public ResultsWrapper handleEmptyResults(@Context MessageContext context, @FormParam("") @Valid HealthRequest data, HealthQuoteEndpointService healthQuoteTokenService, InfoHealth info) {
        NoResultsObj results = new NoResultsObj();

        NoResults noResults = new NoResults();
        noResults.setAvailable(AvailableType.N);
        noResults.setProductId("PHIO-*NONE");
        noResults.setServiceName("PHIO");

        results.setInfo(info);
        results.setResult(Collections.singletonList(noResults));

        // create resultsWrapper with the token
        return healthQuoteTokenService.createResultsWrapper(context.getHttpServletRequest(), data.getTransactionId(), results);
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
