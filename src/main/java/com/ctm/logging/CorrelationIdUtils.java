package com.ctm.logging;

import javax.servlet.http.HttpServletRequest;
import java.net.HttpURLConnection;

public class CorrelationIdUtils {

    public static final ThreadLocal threadLocalCorrelationId = new ThreadLocal();

    public static final String CORRELATION_ID_HEADER = "x-correlation-id";

    public static void clearCorrelationId() {
        threadLocalCorrelationId.remove();
    }

    /**
     * sets correlation id on thread local
     */
    public static void setCorrelationId(String correlationId) {
        threadLocalCorrelationId.set(correlationId);
    }

    public static void setCorrelationIdHeader(HttpURLConnection connection) {
        connection.setRequestProperty(CORRELATION_ID_HEADER , getCorrelationId());
    }

    public static String getCorrelationId(HttpServletRequest request) {
        return request.getHeader(CORRELATION_ID_HEADER);
    }

    /**
     * gets correlation id off thread local
     * @return correlation id
     */
    public static String getCorrelationId(){
        return (String) threadLocalCorrelationId.get();
    }
}
