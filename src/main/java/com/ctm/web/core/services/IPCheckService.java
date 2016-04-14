package com.ctm.web.core.services;

import com.ctm.web.core.dao.IpAddressDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.IpAddress;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.utils.RequestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.commonlogging.common.LoggingArguments.v;

public class IPCheckService {

	private static final Logger LOGGER = LoggerFactory.getLogger(IPCheckService.class);
    private final IPAddressHandler ipAddressHandler;

    private final IpAddressDao ipAddressDao;

    public enum IPCheckStatus{
        OVER(1),
        LIMIT(0),
        UNDER(-1);

        private final Integer status;

        IPCheckStatus(Integer status) {
            this.status = status;
        }

        public Integer getLabel() {
            return status;
        }
    }

    @SuppressWarnings("unused") // used in jsp
    public IPCheckService() {
        ipAddressDao = new IpAddressDao();
        this.ipAddressHandler =  IPAddressHandler.getInstance();
    }

    public IPCheckService(IpAddressDao ipAddressDao, IPAddressHandler ipAddressHandler) {
        this.ipAddressDao = ipAddressDao;
        this.ipAddressHandler = ipAddressHandler;
    }

    /**
     * Are they permitted access based on their IP Address, role and number of hits?
     *
     * Increments the count of IP attempts
     *
     * @param request
     * @param pageSettings
     * @return
     */
    public boolean isPermittedAccess(HttpServletRequest request, PageSettings pageSettings) {

        try {
            // Get status before adding new request
            IPCheckStatus permitted = isWithinLimit(request, pageSettings);

            // Insert/Update IP request
            Long ipAddress = getIPAddressAsLong(request, pageSettings);
            if (ipAddress != 0) {
                IpAddress ipAddressModel = ipAddressDao.findMatch(pageSettings, ipAddress);
                if (ipAddressModel != null) {
                    ipAddressDao.insertOrUpdateRecord(ipAddressModel);
                    }
                }

            // Write to travel session when limit reached
            if (permitted == IPCheckStatus.LIMIT && pageSettings.getVerticalCode().equals("travel")) {
                TransactionDetailsDao transactionDetailsDao = new TransactionDetailsDao();
                transactionDetailsDao.insertOrUpdate("travel/blockedQuote", "true", RequestUtils.getTransactionIdFromRequest(request));
            }

            // Fail if limit reached/exceeded
            if(permitted == IPCheckStatus.LIMIT || permitted == IPCheckStatus.OVER) {
                return false;
            }
        } catch (DaoException e) {
            LOGGER.error("An error occurred while logging the user's IP Address", e);
        }
        return true;
    }

    /**
     * isWithinLimit - does a passive check of current IP request count without
     * incrementing the counter
     *
     * @param request
     * @param pageSettings
     * @return
     */
    private IPCheckStatus isWithinLimit(HttpServletRequest request, PageSettings pageSettings) {
        try {
            Long ipAddress = getIPAddressAsLong(request, pageSettings);
            if (ipAddress != 0) {
                IpAddress ipAddressModel = ipAddressDao.findMatch(pageSettings, ipAddress);
                if (ipAddressModel != null) {
                    int limit = ipAddressModel.getRole().getLimit(pageSettings);
                    // If they have hit more than the limit for their role, they are NOT permitted access.
                    if (ipAddressModel.getNumberOfHits() > limit) {
                        LOGGER.warn("[IPCheckService] User's IP Address has been blocked after exceeding limit. {},{},{}" , kv("ipAddress",
                                ipAddressHandler.getIPAddress(request, pageSettings)), kv("limit", limit), kv("ipAddressModel", ipAddressModel));
                        return IPCheckStatus.OVER;
                    } else if (ipAddressModel.getNumberOfHits() == limit) {
                        LOGGER.warn("[IPCheckService] User's IP Address has been blocked after reaching limit. {},{},{}" , v("ipAddress",
                                ipAddressHandler.getIPAddress(request, pageSettings)), kv("limit", limit), kv("ipAddressModel", ipAddressModel));
                        return IPCheckStatus.LIMIT;
                    }
                }
            }
        } catch (DaoException e) {
            LOGGER.error("[IPCheckService] An error occurred while checking the count of requests from the user's IP Address", e);
        }
        return IPCheckStatus.UNDER;
    }

    /**
     * isPermittedAccessAlt - overloaded the standard isPermittedAccess method to allow it to be called
     * via ajax requests to routing end points (which won't be able to send pageSettings object)
     *
     * @param request
     * @param vertical
     * @return
     */
    public boolean isPermittedAccessAlt(HttpServletRequest request, Vertical.VerticalType vertical) {
        try {
            PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, vertical.getCode());
            return isPermittedAccess(request, pageSettings);
        } catch(ConfigSettingException | DaoException e) {
            LOGGER.error("An exception was thrown getting the pageSettings object {}", kv("vertical", vertical), e);
        }
        return true;
    }


    /**
     * Formula for converting an IP to a long.
     * (first octet * 256^3) + (second octet * 256^2) + (third octet * 256) + (fourth octet)
     * =	(first octet * 16777216) + (second octet * 65536) + (third octet * 256) + (fourth octet)
     * =	(202 * 16777216) + (56 * 65536) + (61 * 256) + (2)
     * =	3392683266
     *
     * @param request
     * @param pageSettings
     * @return
     * @source: http://www.mkyong.com/java/java-convert-ip-address-to-decimal-number/
     */
    public long getIPAddressAsLong(HttpServletRequest request, PageSettings pageSettings) {

        String[] ipAddressInArray = ipAddressHandler.getIPAddress(request, pageSettings).split("\\.");

        long result = 0;
        if (ipAddressInArray.length > 1) {
            for (int i = 0; i < ipAddressInArray.length; i++) {

                int power = 3 - i;
                int ip = Integer.parseInt(ipAddressInArray[i]);
                result += ip * Math.pow(256, power);

            }
        }
        return result;
    }

}
