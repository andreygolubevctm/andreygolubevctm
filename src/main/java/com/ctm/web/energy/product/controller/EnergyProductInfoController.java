package com.ctm.web.energy.product.controller;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.energy.form.model.EnergyProductInfoWebRequest;
import com.ctm.web.energy.form.model.EnergyProviderWebRequest;
import com.ctm.web.energy.form.response.model.EnergyProductInfoWebResponse;
import com.ctm.web.energy.form.response.model.EnergyProvidersWebResponse;
import com.ctm.web.energy.services.EnergyProductResultsService;
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

@Api(basePath = "/rest/energy", value = "Energy Product Info")
@RestController
@RequestMapping("/rest/energy")
public class EnergyProductInfoController extends CommonQuoteRouter<EnergyProductInfoWebRequest> {

    @Autowired
    private EnergyProductResultsService energyProductResultsService;

    @ApiOperation(value = "moreinfo/get.json", notes = "Request a energy product information", produces = "application/json")
    @RequestMapping(value = "/moreinfo/get.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public EnergyProductInfoWebResponse getQuote(@Valid EnergyProductInfoWebRequest quoteRequest,
                                               HttpServletRequest request) throws IOException, ServiceConfigurationException, DaoException {
        Brand brand = initRouter(request, Vertical.VerticalType.ENERGY);
        updateTransactionIdAndClientIP(request, quoteRequest);
        return energyProductResultsService.getResults(quoteRequest, brand);
    }



}
