package com.ctm.web.travel.router;

import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ResultsObj;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.model.results.TravelResult;
import com.ctm.web.travel.services.TravelService;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.List;

@RestController
@RequestMapping("/rest/travel")
public class TravelQuoteController extends CommonQuoteRouter<TravelRequest> {

    @Autowired
    private TravelService travelService;

    @Autowired
    public TravelQuoteController(SessionDataServiceBean sessionDataServiceBean) {
        super(sessionDataServiceBean);
    }

    @RequestMapping(value = "/quote/get.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResultsWrapper getTravelQuote(@Valid final TravelRequest data, HttpServletRequest request) throws Exception {

        Vertical.VerticalType vertical = Vertical.VerticalType.TRAVEL;

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


}
