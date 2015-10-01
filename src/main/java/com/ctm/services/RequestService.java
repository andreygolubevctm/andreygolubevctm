package com.ctm.services;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.PageRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.utils.RequestUtils;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.HttpRequestHandler;
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
    public String token;
    private String ipAddress;

    public RequestService(HttpServletRequest request, String vertical){
        transactionId = RequestUtils.getTransactionIdFromRequest(request);
        this.request = request;
        init(request, vertical);
    }

    public RequestService(HttpServletRequest request, Vertical.VerticalType vertical){
        transactionId = RequestUtils.getTransactionIdFromRequest(request);
        this.request = request;
        init(request, vertical.getCode());
    }

    public RequestService(Vertical.VerticalType vertical, PageSettings pageSettings){
        this.vertical = vertical;
        this.pageSettings = pageSettings;
    }
    
    public void setRequest(HttpServletRequest request) {
        transactionId = RequestUtils.getTransactionIdFromRequest(request);
        IPCheckService ipCheckService= new IPCheckService();
        this.ipAddress = ipCheckService.getIPAddress(request);
        this.request = request;
        init(request, vertical.getCode());
    }


    public RequestService(HttpServletRequest request, String vertical, Data data){
        this.request = request;
        transactionId = data.getLong("current/transactionId");
        init(request, vertical);
    }

    private void init(HttpServletRequest request, String vertical) {
        this.token = RequestUtils.getTokenFromRequest(request);
        sessionId = request.getSession().getId();
        ApplicationService.setVerticalCodeOnRequest(request, vertical);
        try {
            if(pageSettings == null) {
                pageSettings = SettingsService.getPageSettingsForPage(request);
            }
            styleCodeId = pageSettings.getBrandId();
        } catch (DaoException | ConfigSettingException e) {
           LOGGER.error("Error getting page settings",e);
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

    public HttpServletRequest getRequest() {
        return request;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void parseCommonValues(PageRequest request) {
        request.setTransactionId(transactionId);
        request.setToken(token);
        request.setIpAddress(getIpAddress());
    }
}
