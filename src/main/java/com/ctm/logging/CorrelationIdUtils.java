package com.ctm.logging;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import java.net.URLConnection;
import java.util.Optional;

public class CorrelationIdUtils {

    private static final ThreadLocal<String> threadLocalCorrelationId = new ThreadLocal<>();

    private static final String CORRELATION_ID_HEADER = "x-correlation-id";

    public static void clearCorrelationId() {
        threadLocalCorrelationId.remove();
    }

    /**
     * sets correlation id on thread local
     */
    public static void setCorrelationId(Optional<String> correlationIdMaybe) {
        correlationIdMaybe.ifPresent(threadLocalCorrelationId::set);
    }

    /**
     * sets correlation id on thread local
     */
    public static void setCorrelationId(String correlationId) {
        threadLocalCorrelationId.set(correlationId);
    }

    public static void setCorrelationIdHeader(URLConnection connection) {
        getCorrelationId().ifPresent(correlationId -> connection.setRequestProperty(CORRELATION_ID_HEADER, correlationId));
    }

    public static Optional<String> getCorrelationId(ServletRequest request) {
        if(request instanceof HttpServletRequest) {
            return Optional.ofNullable(((HttpServletRequest) request).getHeader(CORRELATION_ID_HEADER));
        } else {
            return Optional.empty();
        }
    }

    /**
     * gets correlation id off thread local
     * @return correlation id
     */
    public static Optional<String> getCorrelationId(){
        return Optional.ofNullable(threadLocalCorrelationId.get());
    }
}
