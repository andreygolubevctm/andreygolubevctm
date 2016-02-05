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
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

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
    public CarQuoteController(SessionDataServiceBean sessionDataServiceBean) {
        super(sessionDataServiceBean);
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
}
