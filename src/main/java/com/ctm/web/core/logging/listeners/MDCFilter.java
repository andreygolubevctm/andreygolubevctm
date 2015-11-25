package com.ctm.web.core.logging.listeners;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.commonlogging.correlationid.CorrelationIdUtils;
import com.ctm.interfaces.common.types.BrandCode;
import com.ctm.interfaces.common.types.CorrelationId;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.interfaces.common.types.VerticalType;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Optional;

import static com.ctm.commonlogging.correlationid.CorrelationIdUtils.getCorrelationId;
import static com.ctm.interfaces.common.types.VerticalType.GENERIC;
import static com.ctm.web.core.utils.RequestUtils.*;
import static java.util.Optional.empty;
import static java.util.Optional.ofNullable;

public class MDCFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        CorrelationId correlationId = correlationId(req).orElseGet(CorrelationIdUtils::generateCorrelationId);
        Optional<TransactionId> transactionId = ofNullable(req.getParameter(TRANSACTION_ID_PARAM)).map(Long::parseLong).map(TransactionId::instanceOf);
        VerticalType verticalType = ofNullable(req.getParameter(VERTICAL_PARAM)).map(VerticalType::findByCode).orElse(GENERIC);
        Optional<BrandCode> brandCode = ofNullable(req.getParameter(BRAND_CODE_PARAM)).map(BrandCode::instanceOf);

        LoggingVariables.setCorrelationId(correlationId);
        LoggingVariables.setVerticalType(verticalType);
        transactionId.ifPresent(LoggingVariables::setTransactionId);
        brandCode.ifPresent(LoggingVariables::setBrandCode);
        try {
            chain.doFilter(req, resp);
        } finally {
            LoggingVariables.clearLoggingContext();
        }
    }

    private Optional<CorrelationId> correlationId(ServletRequest req) {
        return (req instanceof HttpServletRequest) ? getCorrelationId((HttpServletRequest) req) : empty();
    }

    @Override
    public void destroy() {
    }

}
