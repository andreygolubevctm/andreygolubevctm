package com.ctm.web.core.openinghours.api.controller;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.openinghours.api.model.request.OpeningHoursRequest;
import com.ctm.web.core.openinghours.api.model.response.OpeningHoursResponse;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.services.ApplicationService.setVerticalCodeOnRequest;

@RestController
@RequestMapping("/openinghours")
public class OpeningHoursController extends CommonQuoteRouter<OpeningHoursRequest> {
    private static final Logger LOGGER = LoggerFactory.getLogger(OpeningHoursController.class);

    @Autowired
    private OpeningHoursService openingHoursService;

    @Autowired
    public OpeningHoursController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, ipAddressHandler);
    }

    @RequestMapping(value = "/get.json", method= RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public OpeningHoursResponse getOpeningHours(@RequestParam("vertical") String vertical, HttpServletRequest request) throws DaoException,ConfigSettingException {
        setVerticalCodeOnRequest(request, vertical.toUpperCase());
        String openingHours = openingHoursService.getCurrentOpeningHoursForEmail(request);
        return new OpeningHoursResponse(openingHours);
    }

    @RequestMapping(value = "/data.json", method= RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public List<OpeningHours> getOpeningHoursData(@RequestParam("vertical") String vertical, HttpServletRequest request, HttpServletResponse response) throws DaoException,ConfigSettingException {
        addAllowOriginHeader(request, response);
        setVerticalCodeOnRequest(request, vertical.toUpperCase());
        return openingHoursService.getAllOpeningHoursForDisplay(request);
    }

    private void addAllowOriginHeader(final HttpServletRequest request, final HttpServletResponse response) {
        final Optional<String> origin = Optional.ofNullable(request.getHeader("Origin"))
                .map(String::toLowerCase)
                .filter(s -> s.contains("comparethemarket.com.au"));
        if(origin.isPresent()) {
            LOGGER.debug("Adding Allow-Origin header for: {}", kv("remote address access", origin));
            response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
        }
    }
}
