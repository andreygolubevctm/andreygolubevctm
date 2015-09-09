package com.ctm.logging;

import org.slf4j.MDC;

public class LoggingVariables {

    private static final String TRANSACTION_ID_KEY = "transactionId";
    private static final String BRAND_CODE_KEY = "brandCode";
    private static final String VERTICAL_CODE_KEY = "verticalCode";

    public static void clearLoggingVariables() {
        MDC.remove(TRANSACTION_ID_KEY);
        MDC.remove(BRAND_CODE_KEY);
        MDC.remove(VERTICAL_CODE_KEY);
    }

    public static void setLoggingVariables(String transactionId, String brandCode, String verticalCode) {
        setTransactionId(transactionId);
        MDC.put(BRAND_CODE_KEY, brandCode);
        MDC.put(VERTICAL_CODE_KEY, verticalCode);
    }


    public static void setTransactionId(String transactionId) {
        MDC.put(TRANSACTION_ID_KEY, transactionId);
    }
}
