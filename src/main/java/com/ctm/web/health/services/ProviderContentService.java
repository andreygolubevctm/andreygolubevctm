package com.ctm.web.health.services;

import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.dao.ProviderContentDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.NumberUtils;
import org.springframework.util.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class ProviderContentService {

    private static final Logger LOGGER = LoggerFactory.getLogger(Data.class);

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
    public String getProviderContentText(HttpServletRequest request, String providerName,
                                         String providerContentTypeCode) throws DaoException, ConfigSettingException {
        ProviderDao providerDao = new ProviderDao();
        Date currDate = ApplicationService.getApplicationDate(request);
        int providerId = providerDao.getByName(providerName, currDate).getId();
        return providerContentDao.getProviderContentText(providerId, providerContentTypeCode, "HEALTH", currDate);
    }

    public String getProviderContentText(HttpServletRequest request) throws ServiceException {
        String providerIdString = request.getParameter("providerId");
        String providerContentTypeCode = request.getParameter("providerContentTypeCode");
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
            return providerContentDao.getProviderContentText(providerId, providerContentTypeCode, "HEALTH", currDate);
        } catch (DaoException e) {
            throw new ServiceException("Failed to get provider content text.", e);
        }
    }

}
