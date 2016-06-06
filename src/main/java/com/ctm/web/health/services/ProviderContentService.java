package com.ctm.web.health.services;

import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.health.dao.ProviderContentDao;
import com.ctm.web.health.dao.ProviderInfoDao;
import com.ctm.web.health.model.providerInfo.ProviderInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

@Component
public class ProviderContentService {

    private final ProviderContentDao providerContentDao = new ProviderContentDao();
    private final ProviderInfoDao providerInfoDao;
    private final ProviderDao providerDao;

    @Autowired
    public ProviderContentService(ProviderInfoDao providerInfoDao, ProviderDao providerDao) {
        this.providerInfoDao = providerInfoDao;
        this.providerDao = providerDao;
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

    public ProviderInfo getProviderInfo(HttpServletRequest request, String providerName) throws DaoException {
        Date currDate = ApplicationService.getApplicationDate(request);
        Brand brand = ApplicationService.getBrandFromRequest(request);
        Provider provider = providerDao.getByName(providerName, currDate);
        return providerInfoDao.getProviderInfo(provider, brand, currDate);
    }


}
