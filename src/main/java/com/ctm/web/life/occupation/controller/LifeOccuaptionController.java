package com.ctm.web.life.occupation.controller;

import com.ctm.life.occupation.model.response.Occupation;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.life.services.LifeOccupationService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Api(basePath = "/rest/life", value = "Life Occupation")
@RestController
@RequestMapping("/rest/life")
public class LifeOccuaptionController extends CommonQuoteRouter {

    @Autowired
    private LifeOccupationService lifeOccupationService;

    @Autowired
    public LifeOccuaptionController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, ipAddressHandler);
    }

    @ApiOperation(value = "occupation/list.json", notes = "Request a list of Life occupations", produces = "application/json")
    @RequestMapping(value = "/occupation/list.json",
            method= RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Occupation> getQuote(HttpServletRequest request) throws IOException, ServiceConfigurationException, DaoException {
        Brand brand = initRouter(request, Vertical.VerticalType.LIFE);
        return lifeOccupationService.getOccupations(brand);
    }

}
