package com.ctm.web.health.router;

import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.callback.model.HealthCallBackData;
import com.ctm.web.health.services.HealthCallBackService;
import io.swagger.annotations.Api;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.validation.constraints.NotNull;

@Api(basePath = "/rest/health", value = "Health CallBack")
@RestController
@RequestMapping("/rest/health")
public class HealthCallBackController extends CommonQuoteRouter {

    public static final String CALL_ME_NOW = "callMeNow";
    public static final String CALL_ME_BACK = "callMeBack";

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
        final Data dataBucket = getDataBucket(request, data.getTransactionId());
        if (StringUtils.isBlank(data.getScheduledDateTime())) {
            throw new RouterException("Scheduled date time is mandatory");
        }
        healthCallBackService.sendLead(data, dataBucket, request, CALL_ME_BACK);
    }

    @RequestMapping(value = "/callMeNow.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"})
    public void callMeNow(@Valid @NotNull final HealthCallBackData data, HttpServletRequest request) throws Exception {
        final Data dataBucket = getDataBucket(request, data.getTransactionId());
        healthCallBackService.sendLead(data, dataBucket, request, CALL_ME_NOW);
    }

}
