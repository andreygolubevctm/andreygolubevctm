package com.ctm.listeners;

import com.ctm.logging.LoggingVariables;
import com.ctm.model.settings.Vertical;
import org.slf4j.MDC;

import javax.servlet.*;
import java.io.IOException;

public class MDCFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        MDC.put("transactionId", req.getParameter("transactionId"));
        MDC.put("brandCode", req.getParameter("brandCode"));
        String vertical = req.getParameter("vertical");
        String verticalCode= "";
        if(vertical != null) {
            verticalCode =  Vertical.VerticalType.findByCode(vertical).getCode();
        }
        LoggingVariables.setLoggingVariables(req.getParameter("transactionId"), req.getParameter("brandCode"), verticalCode);
        try {
            chain.doFilter(req, resp);
        } finally {
            LoggingVariables.clearLoggingVariables();
        }
    }

    @Override
    public void destroy() {
    }

}
