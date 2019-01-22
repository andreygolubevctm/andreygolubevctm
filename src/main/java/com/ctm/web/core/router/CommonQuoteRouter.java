package com.ctm.web.core.router;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.exceptions.*;
import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.resultsData.Error;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.resultsData.model.Info;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.IPCheckService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.services.tracking.TrackingKeyService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.ValidationUtils;
import com.ctm.web.core.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.Optional;

public abstract class CommonQuoteRouter<REQUEST extends Request> extends CommonRouter {

    protected final IPAddressHandler ipAddressHandler;
    protected SessionDataServiceBean sessionDataServiceBean;
    private VerticalType verticalType = VerticalType.GENERIC;

    public CommonQuoteRouter(SessionDataServiceBean sessionDataServiceBean, ApplicationService applicationService, IPAddressHandler ipAddressHandler) {
        super(applicationService);
        this.sessionDataServiceBean = sessionDataServiceBean;
        this.ipAddressHandler = ipAddressHandler;
    }

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonQuoteRouter.class);

    public CommonQuoteRouter(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(new ApplicationService());
        this.sessionDataServiceBean = sessionDataServiceBean;
        this.ipAddressHandler = ipAddressHandler;
    }

    protected Brand initRouter(MessageContext context, Vertical.VerticalType vertical){
        return initRouter(context.getHttpServletRequest(), vertical);
    }

    protected Brand initRouter(HttpServletRequest request) {
        return initRouter(request, Vertical.VerticalType.findByCode(getVerticalType().toString()));
    }

    protected SessionDataServiceBean getSessionDataServiceBean() {
        return sessionDataServiceBean;
    }

    protected Data getDataBucket(MessageContext context, Long transactionId) {
        return getDataBucket(context.getHttpServletRequest(),  transactionId);
    }

    protected Data getDataBucket(HttpServletRequest request, Long transactionId) {
        try {
            return sessionDataServiceBean.getDataForTransactionId(request, transactionId.toString(), true);
        } catch (DaoException | SessionException | SessionExpiredException e) {
            throw new RouterException(e);
        }
    }

    protected String updateTransactionIdAndClientIP(MessageContext context, REQUEST data){
        return updateTransactionIdAndClientIP(context.getHttpServletRequest(),  data);
    }

    protected String updateTransactionIdAndClientIP(HttpServletRequest request, REQUEST data){
        final String clientIpAddress;
        Data dataBucket = getDataBucket(request, data.getTransactionId());

        if(dataBucket != null && dataBucket.getString("current/transactionId") != null){
            data.setTransactionId(Long.parseLong(dataBucket.getString("current/transactionId")));
        }
        if (StringUtils.isBlank((String) dataBucket.get("quote/clientIpAddress"))) {
            clientIpAddress = ipAddressHandler.getIPAddress(request);
        } else {
            clientIpAddress = (String) dataBucket.get("quote/clientIpAddress");
        }
        data.setClientIpAddress(clientIpAddress);

        return clientIpAddress;
    }

    protected Info generateInfoKey(final REQUEST data, final MessageContext context) {
        return generateInfoKey(data, context.getHttpServletRequest());
    }

    protected Info generateInfoKey(final REQUEST data, final HttpServletRequest request) {
        // Generate the Tracking Key for Omniture tracking
        Info info = new Info();
        info.setTransactionId(data.getTransactionId());
        try {
            String trackingKey = TrackingKeyService.generate(
                    request, data.getTransactionId());
            info.setTrackingKey(trackingKey);
        } catch (Exception e) {
            throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
        }
        return info;
    }

    protected void checkIPAddressCount(Brand brand, Vertical.VerticalType vertical, MessageContext context) {
        checkIPAddressCount(brand, vertical, context.getHttpServletRequest());
    }

    protected void checkIPAddressCount(Brand brand, Vertical.VerticalType vertical, HttpServletRequest request) {
        IPCheckService ipCheckService = new IPCheckService();
        PageSettings pageSettings = getPageSettingsByCode(brand, vertical);
        if(!ipCheckService.isPermittedAccess(request, pageSettings)) {
            LOGGER.error("Access attempts exceeded for IP {} in {}", ipAddressHandler.getIPAddress(request), vertical.getCode());
            throw new RouterException("Access attempts exceeded");
        }
    }

    protected PageSettings getPageSettingsByCode(Brand brand, Vertical.VerticalType vertical) {
        return SettingsService.getPageSettingsByBrand(brand, vertical.getCode());
    }

    protected void updateApplicationDate(MessageContext context, REQUEST data) {
        updateApplicationDate(context.getHttpServletRequest(), data);
    }

    protected void updateApplicationDate(HttpServletRequest request, REQUEST data) {
        getApplicationDate(request).ifPresent(data::setRequestAt);
    }

    protected Optional<LocalDateTime> getApplicationDate(HttpServletRequest request) {
        final Date date = ApplicationService.getApplicationDateIfSet(request);
        if (date != null) {
            return Optional.of(LocalDateTime.ofInstant(date.toInstant(), ZoneId.systemDefault()));
        }
        return Optional.empty();
    }


    @ExceptionHandler(BindException.class)
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Error handleValidationException(BindException e, HttpServletRequest request) {
        LoggingVariables.setVerticalType(getVerticalType());
        LOGGER.warn("Validation failure encountered", e);
        return FormValidation.outputToObject(RequestUtils.getTransactionIdFromRequest(request), ValidationUtils.handleSpringValidationErrors(e));
    }


    @ExceptionHandler(RouterException.class)
    @ResponseStatus(HttpStatus.ACCEPTED)
    public com.ctm.web.core.model.resultsData.Error handleException(final RouterException e) {
        if(e.getValidationErrors() == null){
            throw new RuntimeException(e);
        }
        LOGGER.error("Validation failure encountered", e);
        return FormValidation.outputToObject(e.getTransactionId(), e.getValidationErrors());
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorInfo handleException(final ServiceRequestException e) {
        LOGGER.error("Failed to handle request", e);
        ErrorInfo errorInfo = new ErrorInfo();
        errorInfo.setTransactionId(e.getTransactionId());
        errorInfo.setErrors(e.getErrors());
        return errorInfo;
    }



    protected VerticalType getVerticalType() {
        return verticalType;
    }
}
