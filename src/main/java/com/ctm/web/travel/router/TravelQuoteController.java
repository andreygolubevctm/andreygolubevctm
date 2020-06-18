package com.ctm.web.travel.router;

import com.ctm.web.core.model.ProviderName;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ResultsObj;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.model.results.TravelResult;
import com.ctm.web.travel.services.TravelProviderNameService;
import com.ctm.web.travel.services.TravelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.security.AuthorisationConstants.TOKEN_REQUEST_PARAM_ANONYMOUS_ID;
import static com.ctm.web.core.security.AuthorisationConstants.TOKEN_REQUEST_PARAM_USER_ID;

@RestController
@RequestMapping("/rest/travel")
public class TravelQuoteController extends CommonQuoteRouter<TravelRequest> {

    @Autowired
    private TravelService travelService;
    @Autowired
    private TravelProviderNameService providerNameService;

    @Autowired
    public TravelQuoteController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, ipAddressHandler);
    }

    @RequestMapping(value = "/quote/get.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResultsWrapper getTravelQuote(@Valid final TravelRequest data, HttpServletRequest request) throws Exception {

        Vertical.VerticalType vertical = Vertical.VerticalType.TRAVEL;

        // The two IDs below gets populated by the AuthenticationFilter, which extracts them from the relevant JWT token
        final String anonymousId = Optional.ofNullable(request.getAttribute(TOKEN_REQUEST_PARAM_ANONYMOUS_ID)).map(Object::toString).orElse(null);
        final String userId = Optional.ofNullable(request.getAttribute(TOKEN_REQUEST_PARAM_USER_ID)).map(Object::toString).orElse(null);
        data.setAnonymousId(anonymousId);
        data.setUserId(userId);

        // Initialise request
        Brand brand = initRouter(request, vertical);

        updateTransactionIdAndClientIP(request, data);
        updateApplicationDate(request, data);

        checkIPAddressCount(brand, vertical, request);
        // Check IP Address Count

        // Get quotes
        List<TravelResult> travelQuoteResults = travelService.getQuotes(brand, data);

        // Build the JSON object for the front end.
        ResultsObj<TravelResult> results = new ResultsObj<>();
        results.setInfo(generateInfoKey(data, request));
        results.setResult(travelQuoteResults);

        return new ResultsWrapper(results);

    }

    @RequestMapping(value = "/filterProviderList/list.json",
            method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public List<ProviderName> filterProviderNames(HttpServletRequest request, @RequestParam(value = "environmentOverride", required = false) String environmentOverride) throws Exception {

        Vertical.VerticalType vertical = Vertical.VerticalType.TRAVEL;

        // Initialise request
        Brand brand = initRouter(request, vertical);

        checkIPAddressCount(brand, vertical, request);
        // Check IP Address Count

        final Optional<LocalDateTime> applicationDate = getApplicationDate(request);

        // Get Providers
        return providerNameService.getProviderNames(brand, vertical, environmentOverride);
    }

}
