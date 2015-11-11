package com.ctm.web.core.router;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.Info;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.IPCheckService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.services.tracking.TrackingKeyService;
import com.ctm.web.core.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class CommonQuoteRouter<REQUEST extends Request> {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonQuoteRouter.class.getName());

    protected Brand initRouter(MessageContext context, Vertical.VerticalType vertical){
        // - Start common -- taken from Carlos' car branch
        ApplicationService.setVerticalCodeOnRequest(context.getHttpServletRequest(), vertical.getCode());

        try {
            return ApplicationService.getBrandFromRequest(context.getHttpServletRequest());

        } catch (DaoException e) {
            throw new RouterException(e);
        }

    }

    protected Data getDataBucket(MessageContext context, Long transactionId) {
        SessionDataService service = new SessionDataService();
        try {
            return service.getDataForTransactionId(context.getHttpServletRequest(), transactionId.toString(), true);
        } catch (DaoException | SessionException e) {
            throw new RouterException(e);
        }
    }

    protected String updateTransactionIdAndClientIP(MessageContext context, REQUEST data){
        final String clientIpAddress;
        Data dataBucket = getDataBucket(context, data.getTransactionId());

        if(dataBucket != null && dataBucket.getString("current/transactionId") != null){
            data.setTransactionId(Long.parseLong(dataBucket.getString("current/transactionId")));
        }
        if (StringUtils.isBlank((String) dataBucket.get("quote/clientIpAddress"))) {
            clientIpAddress = context.getHttpServletRequest().getRemoteAddr();
        } else {
            clientIpAddress = (String) dataBucket.get("quote/clientIpAddress");
        }
        data.setClientIpAddress(clientIpAddress);

        return clientIpAddress;
    }

    protected Info generateInfoKey(final REQUEST data, final MessageContext context) {
        // Generate the Tracking Key for Omniture tracking
        Info info = new Info();
        info.setTransactionId(data.getTransactionId());
        try {
            String trackingKey = TrackingKeyService.generate(
                    context.getHttpServletRequest(), data.getTransactionId());
            info.setTrackingKey(trackingKey);
        } catch (Exception e) {
            throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
        }
        return info;
    }

    protected void checkIPAddressCount(Brand brand, Vertical.VerticalType vertical, MessageContext context) {
        IPCheckService ipCheckService = new IPCheckService();
        PageSettings pageSettings = getPageSettingsByCode(brand, vertical);
        if(!ipCheckService.isPermittedAccess(context.getHttpServletRequest(), pageSettings)) {
            LOGGER.error("Access attempts exceeded for IP {} in {}", context.getHttpServletRequest().getRemoteAddr(), vertical.getCode());
            throw new RouterException("Access attempts exceeded");
        }
    }

    protected PageSettings getPageSettingsByCode(Brand brand, Vertical.VerticalType vertical) {
        return SettingsService.getPageSettingsByCode(brand.getCode(), vertical.getCode());
    }


}
