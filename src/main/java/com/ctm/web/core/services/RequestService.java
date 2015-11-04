package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.PageRequest;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;


public class RequestService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RequestService.class);
    private PageSettings pageSettings;

    private HttpServletRequest request;
    private Vertical.VerticalType vertical;
    public int styleCodeId = 0;
    public String sessionId;
    public Long transactionId;
    private String token;
    private String ipAddress;

    public RequestService(HttpServletRequest request, Vertical.VerticalType vertical){
        transactionId = RequestUtils.getTransactionIdFromRequest(request);
        this.request = request;
        this.vertical = vertical;
        init(request);
    }

    public RequestService(HttpServletRequest request, String vertical, Data data){
        this.request = request;
        this.vertical = Vertical.VerticalType.findByCode(vertical);
        transactionId = data.getLong("current/transactionId");
        init(request);
    }

    public RequestService(HttpServletRequest request, String vertical, Data data, PageSettings pageSettings){
        this.pageSettings = pageSettings;
        this.request = request;
        this.vertical = Vertical.VerticalType.findByCode(vertical);
        transactionId = data.getLong("current/transactionId");
        init(request);
    }

    public RequestService(Vertical.VerticalType vertical, PageSettings pageSettings){
        this.vertical = vertical;
        this.pageSettings = pageSettings;
    }

    public RequestService(Vertical.VerticalType vertical) {
        this.vertical = vertical;
    }

    public RequestService(HttpServletRequest httpRequest, Vertical.VerticalType vertical, PageSettings pageSettings) {
        transactionId = RequestUtils.getTransactionIdFromRequest(httpRequest);
        this.request = httpRequest;
        this.vertical = vertical;
        this.pageSettings = pageSettings;
        init(request);
    }

    public void setRequest(HttpServletRequest request) {
        transactionId = RequestUtils.getTransactionIdFromRequest(request);
        IPCheckService ipCheckService= new IPCheckService();
        this.ipAddress = ipCheckService.getIPAddress(request);
        this.request = request;
        init(request);
    }

    private void init(HttpServletRequest request) {
        this.token = RequestUtils.getTokenFromRequest(request);
        sessionId = request.getSession().getId();
        ApplicationService.setVerticalCodeOnRequest(request, vertical.getCode());
        try {
            if(pageSettings == null) {
                pageSettings = SettingsService.getPageSettingsForPage(request);
            }
            styleCodeId = pageSettings.getBrandId();
        } catch (DaoException | ConfigSettingException e) {
           LOGGER.error("Error getting page settings",e);
        }
    }

    public HttpServletRequest getRequest() {
        return request;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void parseCommonValues(PageRequest request) {
        request.setTransactionId(transactionId);
        request.setToken(token);
    }

    public String getToken() {
        return token;
    }

    public Long getTransactionId() {
        return transactionId;
    }
}
