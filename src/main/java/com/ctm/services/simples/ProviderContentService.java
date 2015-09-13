package com.ctm.services.simples;

import com.ctm.dao.ProviderDao;
import com.ctm.dao.simples.ProviderContentDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.CrudValidationException;
import com.ctm.exceptions.DaoException;
import com.ctm.helper.simples.ProviderContentHelper;
import com.ctm.model.ProviderContent;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.services.ApplicationService;
import com.ctm.services.SessionDataService;
import com.ctm.services.simples.admin.CrudService;
import com.ctm.utils.RequestUtils;

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
