package com.ctm.utils;

import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;

public class RequestUtils {

    private static final Logger logger = Logger.getLogger(RequestUtils.class.getName());

    public static long getTransactionIdFromRequest(HttpServletRequest request) {
        /**
         * Get the transactionId from the request.
         * It is OK to retrieve the transactionId from the request, as we
         * check further on if its in the data bucket.
         */
        long transactionId = 0L;
        String requestTransactionId = request.getParameter("transactionId");
        if (requestTransactionId != null && !requestTransactionId.isEmpty()) {
            try{
                transactionId = Long.parseLong(requestTransactionId);
            } catch (NumberFormatException e) {
                logger.error(e);
            }
        }
        return transactionId;
    }
}
