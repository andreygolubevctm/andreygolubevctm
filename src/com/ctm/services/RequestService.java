package com.ctm.services;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.settings.PageSettings;
import com.ctm.utils.RequestUtils;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.HttpRequestHandler;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;


public class RequestService {

    private static final Logger logger = Logger.getLogger(RequestService.class.getName());

    private final HttpServletRequest request;
    public int styleCodeId = 0;
    public String sessionId;
    public Long transactionId;

    public RequestService(HttpServletRequest request, String vertical){
        this.request = request;
        transactionId = RequestUtils.getTransactionIdFromRequest(request);
        sessionId = request.getSession().getId();
        ApplicationService.setVerticalCodeOnRequest(request, vertical);
        PageSettings pageSettings = null;
        try {
            pageSettings = SettingsService.getPageSettingsForPage(request);
            styleCodeId = pageSettings.getBrandId();
        } catch (DaoException | ConfigSettingException e) {
           logger.error(e);
        }
    }

    /*
	* TODO: once we are away from the jsp this should be
	* elsewhere and Service should not be aware of HttpServletRequest */
    public Data getRequestData() {
        Data data = new Data();
        HttpRequestHandler.updateXmlNode(data, request, false);
        return data;
    }
}
