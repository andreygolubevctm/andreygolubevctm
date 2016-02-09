package com.ctm.web.core.utils;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.web.core.web.go.Data;

import static java.lang.Long.parseLong;

public class SessionDataUtils {

    public static final String CURRENT_TRANSACTION_ID_XPATH = "current/transactionId";

    public static Long getTransactionId(Data data) {
        return data.getLong(CURRENT_TRANSACTION_ID_XPATH);
    }

    public static void setTransactionId(Data data, String transactionId) {
        data.put(CURRENT_TRANSACTION_ID_XPATH, transactionId);
        LoggingVariables.setTransactionId(TransactionId.instanceOf(parseLong(transactionId)));
    }
}
