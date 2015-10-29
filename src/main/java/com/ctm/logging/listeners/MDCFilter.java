package com.ctm.logging.listeners;

import com.ctm.logging.CorrelationIdUtils;
import com.ctm.web.core.utils.RequestUtils;

import javax.servlet.*;
import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

import static com.ctm.logging.CorrelationIdUtils.clearCorrelationId;
import static com.ctm.logging.CorrelationIdUtils.setCorrelationId;
import static com.ctm.logging.LoggingVariables.clearLoggingVariables;
import static com.ctm.logging.LoggingVariables.setLoggingVariables;
import static com.ctm.web.core.utils.RequestUtils.BRAND_CODE_PARAM;
import static com.ctm.web.core.utils.RequestUtils.TRANSACTION_ID_PARAM;

public class MDCFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        String correlationId;
        Optional<String> maybeCorrId = CorrelationIdUtils.getCorrelationId(req);
        correlationId = maybeCorrId.orElseGet(() -> UUID.randomUUID().toString());
        setLoggingVariables(req.getParameter(TRANSACTION_ID_PARAM), req.getParameter(BRAND_CODE_PARAM), RequestUtils.getVerticalFromRequest(req), correlationId);
        setCorrelationId(correlationId);
        try {
            chain.doFilter(req, resp);
        } finally {
            clearLoggingVariables();
            clearCorrelationId();
        }
    }

    @Override
    public void destroy() {
    }

}
