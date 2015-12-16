package com.ctm.web.energy.apply.controller;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.ServiceRequestException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.resultsData.model.Info;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.utils.MiscUtils;
import com.ctm.web.energy.apply.exceptions.FailedToRegisterException;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.ctm.web.energy.apply.services.EnergyApplyService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Api(basePath = "/rest/energy", value = "Energy Apply")
@RestController
@RequestMapping("/rest/energy")
public class EnergyApplyController extends CommonQuoteRouter<EnergyApplyPostRequestPayload> {
    private static final Logger LOGGER = LoggerFactory.getLogger(EnergyApplyController.class);

    @Autowired
    EnergyApplyService energyService;

    @ApiOperation(value = "apply/apply.json", notes = "Submit an energy application", produces = "application/json")
    @RequestMapping(value = "/apply/apply.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public EnergyApplyWebResponseModel getQuote(@ModelAttribute EnergyApplyPostRequestPayload applyPostReqestPayload,
                                                BindingResult result, HttpServletRequest request) throws IOException, ServiceConfigurationException, DaoException {
        LOGGER.debug("Request parameters={}", MiscUtils.toJson(request.getParameterMap()));

        if (result.hasErrors()) {
            for (ObjectError e : result.getAllErrors()) {
                LOGGER.error("FORM POST MAPPING ERROR: {},", e.toString());
            }
        }

        Brand brand = initRouter(request, Vertical.VerticalType.ENERGY);
        updateTransactionIdAndClientIP(request, applyPostReqestPayload);
        EnergyApplyWebResponseModel outcome = energyService.apply(applyPostReqestPayload, brand, request);
        if (outcome != null) {
            Info info = new Info();
            info.setTransactionId(applyPostReqestPayload.getTransactionId());
        }
        return outcome;
    }



    //@TODO Run the service request through the hibernate validator and then throw a ServiceRequestException
    @ExceptionHandler
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorInfo handleException(final ServiceRequestException e) {
        LOGGER.error("Failed to handle request", e);
        ErrorInfo errorInfo = new ErrorInfo();
        errorInfo.setTransactionId(e.getTransactionId());
        errorInfo.setErrors(e.getErrors());
        return errorInfo;
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorInfo handleException(final FailedToRegisterException e) {
        ErrorInfo errorInfo = new ErrorInfo();
        errorInfo.setTransactionId(e.getTransactionId());
/*        errorInfo.setErrors(e.getErrors());*/
        return errorInfo;
    }

}
