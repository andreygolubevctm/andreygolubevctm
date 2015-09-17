package com.ctm.logging;

import com.ctm.model.settings.Vertical;
import org.slf4j.MDC;

public class LoggingVariables {

    public static final String TRANSACTION_ID_KEY = "transactionId";
    public static final String BRAND_CODE_KEY = "brandCode";
    public static final String VERTICAL_CODE_KEY = "verticalCode";

    public static void clearLoggingVariables() {
        MDC.remove(TRANSACTION_ID_KEY);
        MDC.remove(BRAND_CODE_KEY);
        MDC.remove(VERTICAL_CODE_KEY);
    }

    public static void setLoggingVariables(String transactionId, String brandCode, String vertical) {
        setTransactionId(transactionId);
        MDC.put(BRAND_CODE_KEY, brandCode);
        String verticalCode = null;
        if(vertical != null) {
            verticalCode =  Vertical.VerticalType.findByCode(vertical).getCode();
        }
        setVerticalCode(verticalCode);
    }

    public static void setVerticalCode(String verticalCode) {
        MDC.put(VERTICAL_CODE_KEY, verticalCode);
    }


    public static void setTransactionId(String transactionId) {
        MDC.put(TRANSACTION_ID_KEY, transactionId);
    }
}
