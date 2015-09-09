package com.ctm.listeners;

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
        if(vertical != null) {
            MDC.put("verticalCode", Vertical.VerticalType.findByCode(vertical).getCode());
        }
        try {
            chain.doFilter(req, resp);
        } finally {
            clearMDC();
        }
    }

    private void clearMDC() {
        MDC.remove("transactionId");
        MDC.remove("brandCode");
        MDC.remove("verticalCode");
    }

    @Override
    public void destroy() {
    }

}
