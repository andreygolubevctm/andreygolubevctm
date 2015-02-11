package com.ctm.utils;

import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;

public class RequestUtils {

    private static final Logger logger = Logger.getLogger(RequestUtils.class.getName());

    /**
     * Get the transactionId from the request.
     * If String is not a number return -1
     * It is OK to retrieve the transactionId from the request, as we
     * check further on if its in the data bucket.
     **/
    public static long getTransactionIdFromRequest(HttpServletRequest request) {
        long transactionId = -1L;
        String requestTransactionId = request.getParameter("transactionId");
        if (requestTransactionId != null && !requestTransactionId.isEmpty()) {
            try{
                transactionId = Long.parseLong(requestTransactionId);
            } catch (NumberFormatException e) {
                logger.error("Failed to parse requestTransactionId:"+ requestTransactionId, e);
            }
        }
        return transactionId;
    }
}
