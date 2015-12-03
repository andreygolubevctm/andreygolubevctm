package com.ctm.web.energy.provider.controller;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.energy.form.model.EnergyProviderWebRequest;
import com.ctm.web.energy.form.response.model.EnergyProvidersWebResponse;
import com.ctm.web.energy.services.EnergyProviderResultsService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.IOException;

@Api(basePath = "/rest/energy", value = "Energy Providers")
@RestController
@RequestMapping("/rest/energy")
public class EnergyProvidersController extends CommonQuoteRouter<EnergyProviderWebRequest> {

    @Autowired
    private EnergyProviderResultsService energyProviderResultsService;

    @ApiOperation(value = "providers/get.json", notes = "Request a energy providers list", produces = "application/json")
    @RequestMapping(value = "/providers/get.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public EnergyProvidersWebResponse getQuote(@Valid EnergyProviderWebRequest quoteRequest,
                                               HttpServletRequest request) throws IOException, ServiceConfigurationException, DaoException {
        Brand brand = initRouter(request, Vertical.VerticalType.ENERGY);
        updateTransactionIdAndClientIP(request, quoteRequest);
        return energyProviderResultsService.getResults(quoteRequest, brand);
    }



}
