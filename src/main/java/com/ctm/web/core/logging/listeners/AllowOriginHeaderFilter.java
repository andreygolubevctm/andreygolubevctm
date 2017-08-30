package com.ctm.web.core.logging.listeners;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.commonlogging.correlationid.CorrelationIdUtils;
import com.ctm.interfaces.common.types.BrandCode;
import com.ctm.interfaces.common.types.CorrelationId;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.interfaces.common.types.VerticalType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.commonlogging.correlationid.CorrelationIdUtils.getCorrelationId;
import static com.ctm.interfaces.common.types.VerticalType.GENERIC;
import static com.ctm.web.core.utils.RequestUtils.*;
import static java.lang.Long.parseLong;
import static java.util.Optional.empty;
import static java.util.Optional.ofNullable;

public class AllowOriginHeaderFilter implements Filter {
    private static final Logger LOGGER = LoggerFactory.getLogger(AllowOriginHeaderFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        try {
            HttpServletRequest request = (HttpServletRequest) req;
            HttpServletResponse response = (HttpServletResponse) resp;
            final Optional<String> origin = Optional.ofNullable(request.getHeader("Origin"))
                    .map(String::toLowerCase)
                    .filter(s -> s.contains("comparethemarket.com.au"));
            if (origin.isPresent()) {
                LOGGER.debug("Adding Allow-Origin header for: {}", kv("remote address access", origin));
                response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
            }
        } catch (Exception e) {
            LOGGER.error("Failed to parse request logging context values", e);
        }
        chain.doFilter(req, resp);
    }

    @Override
    public void destroy() {
    }

}
