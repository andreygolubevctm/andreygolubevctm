package com.ctm.web.homecontents.router;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.resultsData.model.ResultsObj;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.homecontents.model.form.HomeRequest;
import com.ctm.web.homecontents.model.results.HomeMoreInfo;
import com.ctm.web.homecontents.model.results.HomeResult;
import com.ctm.web.homecontents.providers.model.request.MoreInfoRequest;
import com.ctm.web.homecontents.services.HomeQuoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HOME;

@RestController
@RequestMapping("/rest/home")
public class HomeQuoteController extends CommonQuoteRouter {

    private VerticalType verticalType = VerticalType.HOME;

    @Autowired
    private HomeQuoteService homeService;

    @Autowired
    public HomeQuoteController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean,  ipAddressHandler);
    }

    @RequestMapping(value = "/quote/get.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResultsWrapper getHomeQuote(@Valid final HomeRequest data, HttpServletRequest request) throws Exception {

        // Initialise request
        Brand brand = initRouter(request);
        updateTransactionIdAndClientIP(request, data);
        updateApplicationDate(request, data);

        final List<HomeResult> quotes = homeService.getQuotes(brand, data);

        homeService.writeTempResultDetails(request, data, quotes);
        ResultsObj<HomeResult> results = new ResultsObj<>();
        results.setResult(quotes);
        results.setInfo(generateInfoKey(data, request));

        return new ResultsWrapper(results);
    }

    @RequestMapping(value = "/more_info/get.json",
            method= RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public HomeMoreInfo moreInfo(@Valid MoreInfoRequest moreInfoRequest,
                                 @RequestParam(value = "environmentOverride", required = false) String environmentOverride, HttpServletRequest request) throws Exception {
        Brand brand = initRouter(request, HOME);
        return homeService.getMoreInfo( brand, moreInfoRequest, getApplicationDate(request), Optional.ofNullable(environmentOverride));
    }

    @Override
    protected VerticalType getVerticalType() {
        return verticalType;
    }

}
