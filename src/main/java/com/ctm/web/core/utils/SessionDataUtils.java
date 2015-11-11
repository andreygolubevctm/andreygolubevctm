package com.ctm.web.core.utils;

import com.ctm.web.core.logging.LoggingVariables;
import com.ctm.web.core.web.go.Data;

public class SessionDataUtils {

    public static final String CURRENT_TRANSACTION_ID_XPATH = "current/transactionId";

    public static Long getTransactionId(Data data) {
        return data.getLong(CURRENT_TRANSACTION_ID_XPATH);
    }

    public static void setTransactionId(Data data, String transactionId) {
        data.put(CURRENT_TRANSACTION_ID_XPATH, transactionId);
        LoggingVariables.setTransactionId(transactionId);
    }
}
