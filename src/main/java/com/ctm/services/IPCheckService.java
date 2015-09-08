package com.ctm.services;

import com.ctm.dao.IpAddressDao;
import com.ctm.dao.transaction.TransactionDetailsDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.IpAddress;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.utils.RequestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.logging.LoggingArguments.kv;
import static com.ctm.logging.LoggingArguments.v;

public class IPCheckService {

	private static final Logger logger = LoggerFactory.getLogger(IPCheckService.class.getName());

    private IpAddressDao ipAddressDao;

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

    public IPCheckService() {
        ipAddressDao = new IpAddressDao();
    }

    public IPCheckService(IpAddressDao ipAddressDao) {
        this.ipAddressDao = ipAddressDao;
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
            Long ipAddress = getIPAddressAsLong(request);
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
            logger.error("An error occurred while logging the user's IP Address", e);
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
    public IPCheckStatus isWithinLimit(HttpServletRequest request, PageSettings pageSettings) {
        try {
            Long ipAddress = getIPAddressAsLong(request);
            if (ipAddress != 0) {
                IpAddress ipAddressModel = ipAddressDao.findMatch(pageSettings, ipAddress);
                if (ipAddressModel != null) {
                    int limit = ipAddressModel.getRole().getLimit(pageSettings);
                    // If they have hit more than the limit for their role, they are NOT permitted access.
                    if (ipAddressModel.getNumberOfHits() > limit) {
                        logger.warn("[IPCheckService] User's IP Address has been blocked after exceeding limit. {},{},{}" , kv("ipAddress", getIPAddress(request)), kv("limit", limit), kv("ipAddressModel", ipAddressModel));
                        return IPCheckStatus.OVER;
                    } else if (ipAddressModel.getNumberOfHits() == limit) {
                        logger.warn("[IPCheckService] User's IP Address has been blocked after reaching limit. {},{},{}" , v("ipAddress", getIPAddress(request)), kv("limit", limit), kv("ipAddressModel", ipAddressModel));
                        return IPCheckStatus.LIMIT;
                    }
                }
            }
        } catch (DaoException e) {
            logger.error("[IPCheckService] An error occurred while checking the count of requests from the user's IP Address", e);
        }
        return IPCheckStatus.UNDER;
    }

    /**
     * isWithinLimitAlt - overloaded the standard isWithinLimit method to allow it to be called
     * via ajax requests to routing end points (which won't be able to send pageSettings object)
     * Does a passive check of current IP request count without incrementing the counter
     *
     * @param request
     * @param vertical
     * @return
     */
    public IPCheckStatus isWithinLimitAlt(HttpServletRequest request, Vertical.VerticalType vertical) {
        try {
            PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, vertical.getCode());
            return isWithinLimit(request, pageSettings);
        } catch(ConfigSettingException | DaoException e) {
            logger.error(" An exception was thrown getting the pageSettings object {}", kv("vertical", vertical.getCode()), e);
        }
        return IPCheckStatus.UNDER;
    }

    public Boolean isWithinLimitAsBoolean(HttpServletRequest request, PageSettings pageSettings) {
        IPCheckStatus status = isWithinLimit(request, pageSettings);
        return !(status == IPCheckStatus.LIMIT || status == IPCheckStatus.OVER);
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
            logger.error("An exception was thrown getting the pageSettings object {}", kv("vertical", vertical), e);
        }
        return true;
    }

    /**
     * Get the REMOTE_ADDR header.
     *
     * @param request
     * @return
     */
    public String getIPAddress(HttpServletRequest request) {
        return request.getRemoteAddr();
    }

    /**
     * Formula for converting an IP to a long.
     * (first octet * 256^3) + (second octet * 256^2) + (third octet * 256) + (fourth octet)
     * =	(first octet * 16777216) + (second octet * 65536) + (third octet * 256) + (fourth octet)
     * =	(202 * 16777216) + (56 * 65536) + (61 * 256) + (2)
     * =	3392683266
     *
     * @param request
     * @return
     * @source: http://www.mkyong.com/java/java-convert-ip-address-to-decimal-number/
     */
    public long getIPAddressAsLong(HttpServletRequest request) {

        String[] ipAddressInArray = getIPAddress(request).split("\\.");

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
