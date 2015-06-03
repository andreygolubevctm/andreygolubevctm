package com.ctm.services;

import com.ctm.dao.IpAddressDao;
import com.ctm.dao.transaction.TransactionDetailsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.IpAddress;
import com.ctm.model.settings.PageSettings;
import com.ctm.utils.RequestUtils;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;

public class IPCheckService {

    private static final Logger logger = Logger.getLogger(IPCheckService.class.getName());

    private IpAddressDao ipAddressDao;

    public IPCheckService() {
        ipAddressDao = new IpAddressDao();
    }

    public IPCheckService(IpAddressDao ipAddressDao) {
        this.ipAddressDao = ipAddressDao;
    }

    /**
     * Are they permitted access based on their IP Address, role and number of hits?
     *
     * @param request
     * @param pageSettings
     * @return
     */
    public boolean isPermittedAccess(HttpServletRequest request, PageSettings pageSettings) {

        try {
            Long ipAddress = getIPAddressAsLong(request);
            if (ipAddress != 0) {
                IpAddress ipAddressModel = ipAddressDao.findMatch(pageSettings, ipAddress);
                if (ipAddressModel != null) {
                    ipAddressDao.insertOrUpdateRecord(ipAddressModel);
                    int limit = ipAddressModel.getRole().getLimit(pageSettings);
                    // If they have hit more than the limit for their role, they are NOT permitted access.
                    if (ipAddressModel.getNumberOfHits() > limit) {
                        logger.warn("User's IP Address (" + getIPAddress(request) + ") has been blocked after reaching " + limit + " requests on " + ipAddressModel.getService());

                        // log an entry into the transaction_details table so we know this particular quote is a blocked quote
                        TransactionDetailsDao transactionDetailsDao = new TransactionDetailsDao();
                        transactionDetailsDao.insertOrUpdate("travel/blockedQuote", "true", RequestUtils.getTransactionIdFromRequest(request));
                        return false;
                    }
                }
            }
        } catch (DaoException e) {
            logger.error("An error occurred while logging the user's IP Address", e);
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
