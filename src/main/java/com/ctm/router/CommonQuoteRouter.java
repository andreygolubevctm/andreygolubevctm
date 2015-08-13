package com.ctm.router;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.formData.Request;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.SessionDataService;
import com.disc_au.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;

public abstract class CommonQuoteRouter<REQUEST extends Request> {

    protected Brand initRouter(MessageContext context){
        // - Start common -- taken from Carlos' car branch
        ApplicationService.setVerticalCodeOnRequest(context.getHttpServletRequest(), Vertical.VerticalType.TRAVEL.getCode());
        Brand brand = null;
        try {
            brand = ApplicationService.getBrandFromRequest(context.getHttpServletRequest());

        } catch (DaoException e) {
            throw new RouterException(e);
        }
        return brand;
    }

    protected String updateClientIP(MessageContext context, REQUEST data){

        SessionDataService service = new SessionDataService();
        String clientIpAddress = null;

        try {
            Data dataBucket = service.getDataForTransactionId(context.getHttpServletRequest(), data.getTransactionId().toString(), true);

            if(dataBucket != null && dataBucket.getString("current/transactionId") != null){
                data.setTransactionId(Long.parseLong(dataBucket.getString("current/transactionId")));
                clientIpAddress = (String) dataBucket.get("quote/clientIpAddress");
            }
            if (StringUtils.isBlank(clientIpAddress)) {
                clientIpAddress = context.getHttpServletRequest().getRemoteAddr();
            }
            data.setClientIpAddress(clientIpAddress);
        } catch (DaoException | SessionException e) {
            throw new RouterException(e);
        }

        return clientIpAddress;
    }

}
