package com.ctm.web.core.utils;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.web.core.web.go.Data;

import static java.lang.Long.parseLong;

public class SessionDataUtils {

    public static final String CURRENT_TRANSACTION_ID_XPATH = "current/transactionId";
    public static final String CURRENT_ROOT_ID_XPATH = "current/rootId";

    public static Long getRootId(Data data) {
        return data.getLong(CURRENT_ROOT_ID_XPATH);
    }

    public static void setRootId(Data data, String rootId) {
        data.put(CURRENT_ROOT_ID_XPATH, rootId);
    }

    public static Long getTransactionId(Data data) {
        return data.getLong(CURRENT_TRANSACTION_ID_XPATH);
    }

    public static void setTransactionId(Data data, String transactionId) {
        data.put(CURRENT_TRANSACTION_ID_XPATH, transactionId);
        LoggingVariables.setTransactionId(TransactionId.instanceOf(parseLong(transactionId)));
    }
}
