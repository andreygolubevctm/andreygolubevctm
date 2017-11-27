package com.ctm.web.car.router;

import com.ctm.web.car.model.CarProduct;
import com.ctm.web.car.model.form.CarRequest;
import com.ctm.web.car.model.results.CarResult;
import com.ctm.web.car.services.CarQuoteService;
import com.ctm.web.car.services.CarVehicleSelectionService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ResultsObj;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.email.EmailUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.Date;
import java.util.List;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.CAR;

@RestController
@RequestMapping("/rest/car")
public class CarQuoteController extends CommonQuoteRouter<CarRequest> {

    @Autowired
    private CarQuoteService carService;
    @Autowired
    private EmailUtils emailUtils;

    private String RANK_PRODUCT_ID = "rank.productId";

    @Autowired
    public CarQuoteController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, ipAddressHandler);
    }

    @RequestMapping(value = "/quote/get.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResultsWrapper getCarQuote(@Valid final CarRequest data, HttpServletRequest request) throws Exception {

        // Initialise request
        final Vertical.VerticalType vertical = CAR;
        Brand brand = initRouter(request, vertical);
        updateTransactionIdAndClientIP(request, data);
        updateApplicationDate(request, data);

        final List<CarResult> quotes = carService.getQuotes(brand, data);

        carService.writeTempResultDetails(request, data, quotes);
        ResultsObj<CarResult> results = new ResultsObj<>();
        results.setResult(quotes);
        results.setInfo(generateInfoKey(data, request));

        return new ResultsWrapper(results);

    }

    @RequestMapping(value = "/more_info/get.json",
            method= RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public CarProduct moreInfo(@RequestParam("code") String productId, HttpServletRequest request) throws DaoException {

        if (productId == null) {
            throw new RouterException("Expecting productId");
        }

        Brand brand = ApplicationService.getBrandFromRequest(request);

        Date applicationDate = ApplicationService.getApplicationDate(request);
        return CarVehicleSelectionService.getCarProduct(applicationDate, productId, brand.getId());
    }

    /**
     * request mapping to retrieve, and persist propensity score for a particular transaction.
     * propensity score is purchase probability score, that will be used by lead service, and dialer service to prioritize leads.
     *
     * @param request
     * @throws DaoException when unable to get property from request
     */
    @RequestMapping(value = "/propensity_score/get.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"}
    )
    public void storePropensityScore(HttpServletRequest request) throws DaoException {
        List<String> rankProductIds = emailUtils.buildParameterList(request, RANK_PRODUCT_ID);
        Long transactionId = Long.parseLong(request.getParameter("transactionId"));

        if(transactionId == null){
            throw new IllegalArgumentException("Invalid TransactionId: " + transactionId);
        }

        if(rankProductIds == null){
            throw new IllegalArgumentException("rank_productId can't be null");
        }

        this.carService.retrieveAndStoreCarQuotePropensityScore(rankProductIds, transactionId);
    }
}
