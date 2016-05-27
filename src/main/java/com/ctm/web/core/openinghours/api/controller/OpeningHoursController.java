package com.ctm.web.core.openinghours.api.controller;

import com.ctm.web.car.model.form.CarRequest;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.openinghours.api.model.request.OpeningHoursRequest;
import com.ctm.web.core.openinghours.api.model.response.OpeningHoursResponse;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/openinghours")
public class OpeningHoursController extends CommonQuoteRouter<OpeningHoursRequest> {

    @Autowired
    private OpeningHoursService openingHoursService;

    @Autowired
    public OpeningHoursController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, ipAddressHandler);
    }

    @RequestMapping(value = "/get.json",
            method= RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public OpeningHoursResponse getOpeningHours(@RequestParam("vertical") String vertical, HttpServletRequest request) throws DaoException,ConfigSettingException {
        ApplicationService.setVerticalCodeOnRequest(request, vertical.toUpperCase());
        openingHoursService = new OpeningHoursService();
        String openingHours = openingHoursService.getCurrentOpeningHoursForEmail(request);
        OpeningHoursResponse response = new OpeningHoursResponse(openingHours);
        return response;
    }

    @RequestMapping(value = "/data.json",
            method= RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public List<OpeningHours> getOpeningHoursData(@RequestParam("vertical") String vertical, HttpServletRequest request) throws DaoException,ConfigSettingException {
        ApplicationService.setVerticalCodeOnRequest(request, vertical.toUpperCase());
        openingHoursService = new OpeningHoursService();
        List<OpeningHours> openingHours = openingHoursService.getAllOpeningHoursForDisplay(request, false);
        return openingHours;
    }
}
