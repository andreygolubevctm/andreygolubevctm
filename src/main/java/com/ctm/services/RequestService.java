package com.ctm.services;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.session.SessionData;
import com.ctm.model.settings.PageSettings;
import com.ctm.utils.RequestUtils;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.HttpRequestHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;


public class RequestService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RequestService.class);

    private final HttpServletRequest request;
    public int styleCodeId = 0;
    public String sessionId;
    public Long transactionId;

    public RequestService(HttpServletRequest request, String vertical, Data data){
        this.request = request;
        transactionId = data.getLong("current/transactionId");
        sessionId = request.getSession().getId();
        ApplicationService.setVerticalCodeOnRequest(request, vertical);
        PageSettings pageSettings = null;
        try {
            pageSettings = SettingsService.getPageSettingsForPage(request);
            styleCodeId = pageSettings.getBrandId();
        } catch (DaoException | ConfigSettingException e) {
           LOGGER.error("Error getting page settings",e);
        }
    }


}
