package com.ctm.logging;

import com.ctm.model.settings.Vertical;
import org.slf4j.MDC;

/**
 * Class to handle MDC logging variable. These values are added to threadlocal and used in logback.xml
 */
public class LoggingVariables {

    public static final String TRANSACTION_ID_KEY = "transactionId";
    public static final String BRAND_CODE_KEY = "brandCode";
    public static final String VERTICAL_CODE_KEY = "verticalCode";
    public static final String CORRELATION_ID_KEY = "correlationId";

    /**
     * Clear all parameters from MDC this includes transactionId, brandCode, verticalCode and correlationId
     * Note: this only clears variables on the current thread. This will need to be called on each thread
     */
    public static void clearLoggingVariables() {
        MDC.remove(TRANSACTION_ID_KEY);
        MDC.remove(BRAND_CODE_KEY);
        MDC.remove(VERTICAL_CODE_KEY);
        MDC.remove(CORRELATION_ID_KEY);
    }

    /**
     * Sets all parameters to MDC
     * Note: this only set variables on the current thread. This will need to be called on each thread
     * call clearLoggingVariables() after thread is no longer being executed to prevent the logging from being in
     * an invalid state when a thread is being reused.
     */
    public static void setLoggingVariables(String transactionId, String brandCode, String vertical, String correlationId) {
         setTransactionId(transactionId);
        MDC.put(BRAND_CODE_KEY, brandCode);
        String verticalCode = null;
        if(vertical != null) {
            verticalCode =  Vertical.VerticalType.findByCode(vertical).getCode();
        }
        setVerticalCode(verticalCode);
        MDC.put(CORRELATION_ID_KEY, correlationId);
    }

    /**
     * Sets verticalCode to MDC to be picked up by the logger
     * Note: this only set verticalCode on the current thread. This will need to be called on each thread
     */
    public static void setVerticalCode(String verticalCode) {
        MDC.put(VERTICAL_CODE_KEY, verticalCode);
    }

    /**
     * Sets verticalCode to MDC to be picked up by the logger
     * Note: this only set transaction on the current thread. This will need to be called on each thread
     */
    public static void setTransactionId(String transactionId) {
        MDC.put(TRANSACTION_ID_KEY, transactionId);
    }

}
