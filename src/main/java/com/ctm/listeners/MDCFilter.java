package com.ctm.listeners;

import javax.servlet.*;
import java.io.IOException;

import static com.ctm.logging.LoggingVariables.clearLoggingVariables;
import static com.ctm.logging.LoggingVariables.setLoggingVariables;
import static com.ctm.utils.RequestUtils.TRANSACTION_ID_PARAM;
import static com.ctm.utils.RequestUtils.BRAND_CODE_PARAM;
import static com.ctm.utils.RequestUtils.VERTICAL_PARAM;

public class MDCFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        setLoggingVariables(req.getParameter(TRANSACTION_ID_PARAM), req.getParameter(BRAND_CODE_PARAM), req.getParameter(VERTICAL_PARAM));
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
