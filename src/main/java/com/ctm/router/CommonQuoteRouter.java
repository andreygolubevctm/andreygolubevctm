package com.ctm.router;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.formData.Request;
import com.ctm.model.resultsData.Info;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.IPCheckService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.services.tracking.TrackingKeyService;
import com.disc_au.web.go.Data;
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

    protected String updateTransactionIdAndClientIP(MessageContext context, REQUEST data){

        SessionDataService service = new SessionDataService();
        final String clientIpAddress;

        try {
            Data dataBucket = service.getDataForTransactionId(context.getHttpServletRequest(), data.getTransactionId().toString(), true);

            if(dataBucket != null && dataBucket.getString("current/transactionId") != null){
                data.setTransactionId(Long.parseLong(dataBucket.getString("current/transactionId")));
            }
            if (StringUtils.isBlank((String) dataBucket.get("quote/clientIpAddress"))) {
                clientIpAddress = context.getHttpServletRequest().getRemoteAddr();
            } else {
                clientIpAddress = (String) dataBucket.get("quote/clientIpAddress");
            }
            data.setClientIpAddress(clientIpAddress);
        } catch (DaoException | SessionException e) {
            throw new RouterException(e);
        }

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
        PageSettings pageSettings = SettingsService.getPageSettingsByCode(brand.getCode(), vertical.getCode());
        if(!ipCheckService.isPermittedAccess(context.getHttpServletRequest(), pageSettings)) {
            LOGGER.error("Access attempts exceeded for IP {} in {}", context.getHttpServletRequest().getRemoteAddr(), vertical.getCode());
            throw new RouterException("Access attempts exceeded");
        }
    }
}
