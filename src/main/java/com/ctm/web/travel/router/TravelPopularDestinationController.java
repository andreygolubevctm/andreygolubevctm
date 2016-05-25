package com.ctm.web.travel.router;

import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.travel.model.results.Country;
import com.ctm.web.travel.services.TravelPopularDestinationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/rest/travel")
public class TravelPopularDestinationController extends CommonQuoteRouter {

    @Autowired
    private TravelPopularDestinationService travelPopularDestinationService;

    @Autowired
    public TravelPopularDestinationController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean,  ipAddressHandler);
    }

    @RequestMapping(value = "/popularDestinations/list.json",
            method=RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Country> getTravelQuote(HttpServletRequest request, @RequestParam(value = "environmentOverride", required = false) String environmentOverride) throws Exception {

        Vertical.VerticalType vertical = Vertical.VerticalType.TRAVEL;

        // Initialise request
        Brand brand = initRouter(request, vertical);

        checkIPAddressCount(brand, vertical, request);
        // Check IP Address Count

        final Optional<LocalDateTime> applicationDate = getApplicationDate(request);

        // Get quotes
        return travelPopularDestinationService.getList(brand, vertical, environmentOverride, applicationDate);
    }
}
