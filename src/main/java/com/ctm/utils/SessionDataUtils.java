package com.ctm.utils;

import com.ctm.logging.LoggingVariables;
import com.disc_au.web.go.Data;

public class SessionDataUtils {

    public static final String CURRENT_TRANSACTION_ID_XPATH = "current/transactionId";

    public static Long getTransactionIdFromTransactionSessionData(Data data) {
        return data.getLong(CURRENT_TRANSACTION_ID_XPATH);
    }

    public static void setTransactionIdFromTransactionSessionData(Data data, String transactionId) {
        data.put(CURRENT_TRANSACTION_ID_XPATH, transactionId);
        LoggingVariables.setTransactionId(transactionId);
    }
}
