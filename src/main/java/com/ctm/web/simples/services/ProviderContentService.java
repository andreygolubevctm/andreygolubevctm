package com.ctm.web.simples.services;

import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.simples.dao.ProviderContentDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.helper.ProviderContentHelper;
import com.ctm.web.core.model.ProviderContent;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.CrudService;
import com.ctm.web.core.utils.RequestUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

public class ProviderContentService implements CrudService{

    private final ProviderContentDao providerContentDao = new ProviderContentDao();
    private final ProviderContentHelper providerContentHelper = new ProviderContentHelper();

    public ProviderContentService() {
    }

    /**
     * For the usage in JSP due to we don't store providerId in transaction data
     * @param request
     * @param providerName
     * @return
     * @throws DaoException
     * @throws ConfigSettingException
     */
    public String getProviderContentText(HttpServletRequest request, String providerName, String providerContentTypeCode) throws DaoException, ConfigSettingException {
        ProviderDao providerDao = new ProviderDao();
        Date currDate = ApplicationService.getApplicationDate(request);
        int providerId = providerDao.getByName(providerName, currDate).getId();
        return providerContentDao.getProviderContentText(providerId, providerContentTypeCode, "HEALTH", currDate);
    }

    public String getProviderContentText(HttpServletRequest request) throws DaoException, ConfigSettingException {
        int providerId = Integer.parseInt(request.getParameter("providerId"));
        String providerContentTypeCode = request.getParameter("providerContentTypeCode");
        Date currDate = ApplicationService.getApplicationDate(request);
        return providerContentDao.getProviderContentText(providerId, providerContentTypeCode, "HEALTH", currDate);
    }

    @Override
    public List<?> getAll(HttpServletRequest request) throws DaoException {
        return providerContentDao.fetchProviderContents(request.getParameter("providerContentTypeCode"));
    }

    @Override
    public Object update(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            ProviderContent providerContent = RequestUtils.createObjectFromRequest(request, new ProviderContent());
            providerContentHelper.validate(providerContent);
            providerContent = RequestUtils.createObjectFromRequest(request, providerContent);
            final String userName = getAuthenticatedData(request).getUid();
            final String ipAddress = request.getRemoteAddr();
            return providerContentDao.updateProviderContent(providerContent, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    @Override
    public Object create(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            ProviderContent providerContent = RequestUtils.createObjectFromRequest(request, new ProviderContent());
            providerContentHelper.validate(providerContent);
            providerContent = RequestUtils.createObjectFromRequest(request, providerContent);
            final String userName = getAuthenticatedData(request).getUid();
            final String ipAddress = request.getRemoteAddr();
            return providerContentDao.createProviderContent(providerContent, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    @Override
    public String delete(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            final String userName = getAuthenticatedData(request).getUid();
            final String ipAddress = request.getRemoteAddr();
            return providerContentDao.deleteProviderContent(Integer.parseInt(request.getParameter("providerContentId")), userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    @Override
    public Object get(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            if(request.getParameter("providerContentId")==null)
                return null;
            return providerContentDao.fetchSingleProviderContent(Integer.parseInt(request.getParameter("providerContentId")));
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }
    
    public AuthenticatedData getAuthenticatedData(HttpServletRequest request) throws DaoException {
        SessionDataService sessionDataService = new SessionDataService();
        if (request.getSession() != null) {
            return sessionDataService.getAuthenticatedSessionData(request);
        } else {
            throw new  DaoException("Session expired");
        }
    }

}
