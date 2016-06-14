package com.ctm.web.life.apply.controller;

import com.ctm.web.core.apply.exceptions.FailedToRegisterException;
import com.ctm.web.core.exceptions.*;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.life.apply.model.request.LifeApplyWebRequest;
import com.ctm.web.life.apply.response.LifeApplyWebResponse;
import com.ctm.web.life.apply.services.LifeApplyService;
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
import javax.validation.Valid;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Api(basePath = "/rest/life", value = "Life Apply")
@RestController
@RequestMapping("/rest/life")
public class LifeApplyController extends CommonQuoteRouter<LifeApplyWebRequest> {
    private static final Logger LOGGER = LoggerFactory.getLogger(LifeApplyController.class);

    @Autowired
    LifeApplyService lifeService;

    @Autowired
    public LifeApplyController(SessionDataServiceBean sessionDataServiceBean, ApplicationService applicationService, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, applicationService, ipAddressHandler);
    }

    @ApiOperation(value = "apply/apply.json", notes = "Submit an life application", produces = "application/json")
    @RequestMapping(value = "/apply/apply.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public LifeApplyWebResponse apply(@Valid LifeApplyWebRequest webRequest,
                                      BindingResult result, HttpServletRequest servletRequest) throws ServiceRequestException {

        if (result.hasErrors()) {
            for (ObjectError e : result.getAllErrors()) {
                LOGGER.error("FORM POST MAPPING ERROR: {},", e.toString());
            }
        }

        Brand brand = initRouter(servletRequest, Vertical.VerticalType.LIFE);
        updateTransactionIdAndClientIP(servletRequest, webRequest);

        try {
            return lifeService.apply(webRequest, brand, servletRequest);
        } catch(ServiceException e) {
            LOGGER.error("Failed to call apply. {}" , kv("webRequest" , webRequest) ,  e);
            ServiceRequestException exception = new ServiceRequestException("Exception encountered when trying to apply", e);
            exception.setTransactionId(webRequest.getTransactionId());
            throw exception;
        }
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorInfo handleException(final FailedToRegisterException e) {
        return lifeService.mapException(e);
    }

}
