package com.ctm.web.health.services;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.dao.ProviderContentDao;
import com.ctm.web.health.dao.ProviderInfoDao;
import com.ctm.web.health.model.providerInfo.ProviderInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.util.NumberUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class ProviderContentService {

    private static final Logger LOGGER = LoggerFactory.getLogger(Data.class);

    private final ProviderContentDao providerContentDao;
    private final ProviderDao providerDao;
    private final ProviderInfoDao providerInfoDao;

    public ProviderContentService() {
        providerDao = new ProviderDao();
        providerInfoDao = new ProviderInfoDao(new NamedParameterJdbcTemplate(SimpleDatabaseConnection.getDataSourceJdbcCtm()));
        providerContentDao = new ProviderContentDao();
    }

    @Autowired
    public ProviderContentService(ProviderInfoDao providerInfoDao, ProviderDao providerDao, ProviderContentDao providerContentDao) {
        this.providerInfoDao = providerInfoDao;
        this.providerDao = providerDao;
        this.providerContentDao = providerContentDao;
    }

    /**
     * For the usage in JSP due to we don't store providerId in transaction data
     * @param request
     * @param providerName
     * @return
     * @throws DaoException
     * @throws ConfigSettingException
     */
    public String getProviderContentText(HttpServletRequest request, String providerName, String styleCode,
                                         String providerContentTypeCode) throws DaoException, ConfigSettingException {
        ProviderDao providerDao = new ProviderDao();
        Date currDate = ApplicationService.getApplicationDate(request);
        int providerId = providerDao.getByName(providerName, currDate).getId();
        return providerContentDao.getProviderContentText(providerId, providerContentTypeCode, "HEALTH", currDate, styleCode);
    }

    public String getProviderContentText(HttpServletRequest request) throws ServiceException {
        String providerIdString = request.getParameter("providerId");
        String providerContentTypeCode = request.getParameter("providerContentTypeCode");
        String styleCode = request.getParameter("styleCode");
        Integer providerId;
        try {
            providerId = NumberUtils.parseNumber(providerIdString, Integer.class);
         } catch (NumberFormatException e) {
            LOGGER.warn("Failed to convert providerId to number. {},{}",
                    kv("providerIdString", providerIdString),
                    kv("providerContentTypeCode", providerContentTypeCode), e);
            throw new ServiceException("Failed to convert providerId to number.", e);
        }
        Date currDate = ApplicationService.getApplicationDate(request);
        try {
            return providerContentDao.getProviderContentText(providerId, providerContentTypeCode, "HEALTH", currDate, styleCode);
        } catch (DaoException e) {
            throw new ServiceException("Failed to get provider content text.", e);
        }
    }

    public ProviderInfo getProviderInfo(HttpServletRequest request, String providerName) throws DaoException {
        Date currDate = ApplicationService.getApplicationDate(request);
        Brand brand = ApplicationService.getBrandFromRequest(request);
        Provider provider = providerDao.getByName(providerName, currDate);
        return providerInfoDao.getProviderInfo(provider, brand, currDate);
    }

    public String getProviderEmail(HttpServletRequest request, String providerName) throws DaoException {
        Date currDate = ApplicationService.getApplicationDate(request);
        Brand brand = ApplicationService.getBrandFromRequest(request);
        Provider provider = providerDao.getByName(providerName, currDate);
        return providerInfoDao.getProviderEmail(provider, brand, currDate);
    }

}
