package com.ctm.web.simples.admin.services;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.ProviderContent;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.CrudService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.health.dao.ProviderContentDao;
import com.ctm.web.health.helper.ProviderContentHelper;

import javax.servlet.http.HttpServletRequest;
import java.util.List;


public class AdminProviderContentService implements CrudService {

    private final IPAddressHandler ipAddressHandler;

    private final ProviderContentHelper providerContentHelper = new ProviderContentHelper();
    private final ProviderContentDao providerContentDao = new ProviderContentDao();

    public AdminProviderContentService(IPAddressHandler ipAddressHandler) {
        this.ipAddressHandler =  ipAddressHandler;
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
            final String ipAddress = ipAddressHandler.getIPAddress(request);
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
            final String ipAddress = ipAddressHandler.getIPAddress(request);
            return providerContentDao.createProviderContent(providerContent, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    @Override
    public String delete(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            final String userName = getAuthenticatedData(request).getUid();
            final String ipAddress = ipAddressHandler.getIPAddress(request);
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
            return providerContentDao.fetchSingleProviderContent(Integer.parseInt(request.getParameter("providerContentId")), Integer.parseInt(request.getParameter("styleCodeId")));
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
