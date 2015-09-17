package com.ctm.logging.listeners;

import com.ctm.logging.CorrelationIdUtils;
import com.ctm.utils.RequestUtils;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.UUID;

import static com.ctm.logging.CorrelationIdUtils.clearCorrelationId;
import static com.ctm.logging.CorrelationIdUtils.setCorrelationId;
import static com.ctm.logging.LoggingVariables.clearLoggingVariables;
import static com.ctm.logging.LoggingVariables.setLoggingVariables;
import static com.ctm.utils.RequestUtils.*;

public class MDCFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        String correlationId = null;
        if(req instanceof HttpServletRequest){
             correlationId = CorrelationIdUtils.getCorrelationId((HttpServletRequest) req);
        }
        if(correlationId == null || correlationId.isEmpty()){
            correlationId = UUID.randomUUID().toString();
        }
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
