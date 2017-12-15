package com.ctm.web.health.router;

import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.resultsData.Error;
import com.ctm.web.core.model.resultsData.ErrorDetails;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.callback.model.HealthCallBackData;
import com.ctm.web.health.services.HealthCallBackService;
import io.swagger.annotations.Api;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.Collections;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeoutException;

import static com.ctm.web.core.leadService.model.LeadType.CALL_ME_BACK;
import static com.ctm.web.core.leadService.model.LeadType.CALL_ME_NOW;

@Api(basePath = "/rest/health", value = "Health CallBack")
@RestController
@RequestMapping("/rest/health")
public class HealthCallBackController extends CommonQuoteRouter {
    private static final Logger LOGGER = LoggerFactory.getLogger(HealthCallBackController.class);

    @Autowired
    private HealthCallBackService healthCallBackService;

    @Autowired
    public HealthCallBackController(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler, HealthCallBackService healthCallBackService) {
        super(sessionDataServiceBean, ipAddressHandler);
        this.healthCallBackService = healthCallBackService;
    }

    @RequestMapping(value = "/callMeBack.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"})
    public void callMeBack(@Valid @NotNull final HealthCallBackData data, HttpServletRequest request) throws Exception {
        if (StringUtils.isBlank(data.getScheduledDateTime())) {
            SchemaValidationError schemaValidationError = new SchemaValidationError();
            schemaValidationError.setMessage("Scheduled date time is mandatory");
            throw new RouterException(data.getTransactionId(), Collections.singletonList(schemaValidationError));
        }
        final Data dataBucket = getDataBucket(request, data.getTransactionId());
        healthCallBackService.sendLead(data, dataBucket, request, CALL_ME_BACK);
    }

    @RequestMapping(value = "/callMeNow.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"})
    public void callMeNow(@Valid @NotNull final HealthCallBackData data, HttpServletRequest request) throws Exception {
        final Data dataBucket = getDataBucket(request, data.getTransactionId());
        healthCallBackService.sendLead(data, dataBucket, request, CALL_ME_NOW);
    }

    @Override
    public Error handleException(RouterException ex) {
        return handleExceptionRest(ex);
    }

    @ExceptionHandler({TimeoutException.class, ExecutionException.class, InterruptedException.class})
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Error handleExceptionRest(final Exception ex) {
        LOGGER.error("Failed to handle request", ex);
        return new Error("error", ex.getMessage(), null, new ErrorDetails(ex.getClass().getCanonicalName()));
    }

    @RequestMapping(value = "/callMeNow.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"})
    public void callMeNowWidget(@Valid @NotNull final HealthCallBackData data, HttpServletRequest request) throws Exception {
        healthCallBackService.sendLead(data, null, request, CALL_ME_NOW);
    }

    @RequestMapping(value = "/callMeBackWidget.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"})
    public void callMeBackWidget(@Valid @NotNull final HealthCallBackData data, HttpServletRequest request) throws Exception {
        if (StringUtils.isBlank(data.getScheduledDateTime())) {
            SchemaValidationError schemaValidationError = new SchemaValidationError();
            schemaValidationError.setMessage("Scheduled date time is mandatory");
            throw new RouterException(data.getTransactionId(), Collections.singletonList(schemaValidationError));
        }

        healthCallBackService.sendLead(data, null, request, CALL_ME_BACK);
    }

}
