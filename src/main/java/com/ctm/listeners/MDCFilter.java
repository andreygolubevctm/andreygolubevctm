package com.ctm.listeners;

import com.ctm.utils.RequestUtils;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.UUID;

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
             correlationId = RequestUtils.getCorrelationId((HttpServletRequest) req);
        }
        if(correlationId == null || correlationId.isEmpty()){
            correlationId = UUID.randomUUID().toString();
        }
        setLoggingVariables(req.getParameter(TRANSACTION_ID_PARAM), req.getParameter(BRAND_CODE_PARAM), req.getParameter(VERTICAL_PARAM), correlationId);
        try {
            chain.doFilter(req, resp);
        } finally {
            clearLoggingVariables();
        }
    }

    @Override
    public void destroy() {
    }

}
