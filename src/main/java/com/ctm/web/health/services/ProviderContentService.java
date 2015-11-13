package com.ctm.web.health.services;

import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.health.dao.ProviderContentDao;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

public class ProviderContentService {

    private final ProviderContentDao providerContentDao = new ProviderContentDao();

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

}
