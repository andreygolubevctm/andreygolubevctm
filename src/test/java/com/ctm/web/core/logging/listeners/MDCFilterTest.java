package com.ctm.web.core.logging.listeners;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.commonlogging.correlationid.CorrelationIdUtils;
import com.ctm.interfaces.common.types.BrandCode;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.model.settings.Vertical;
import junit.framework.Assert;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.FilterChain;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import static com.ctm.interfaces.common.types.VerticalType.CAR;
import static com.ctm.interfaces.common.types.VerticalType.GENERIC;
import static com.ctm.web.core.utils.RequestUtils.BRAND_CODE_PARAM;
import static com.ctm.web.core.utils.RequestUtils.TRANSACTION_ID_PARAM;
import static com.ctm.web.core.utils.RequestUtils.VERTICAL_PARAM;
import static junit.framework.Assert.assertTrue;
import static junit.framework.TestCase.assertEquals;
import static junit.framework.TestCase.assertFalse;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class MDCFilterTest {
    MDCFilter mdcFilter = new MDCFilter();

    @Mock
    ServletRequest req = mock(ServletRequest.class);
    @Mock
    ServletResponse resp = mock(ServletResponse.class);
    @Mock
    FilterChain chain = mock(FilterChain.class);

    @Before
    public void setup() {
        initMocks(this);
    }

    @After
    public void teardown() {
        LoggingVariables.clearLoggingContext();
    }

    @Test
    public void generatesCorrelationId() throws Exception {
        when(req.getParameter(CorrelationIdUtils.CORRELATION_ID_HEADER)).thenReturn(null);
        mdcFilter.doFilter(req, resp, (req, rep) -> assertTrue(LoggingVariables.getCorrelationId().isPresent()));
        assertFalse(LoggingVariables.getCorrelationId().isPresent());
    }

    @Test
    public void handlesEmptyTransactionId() throws Exception {
        when(req.getParameter(TRANSACTION_ID_PARAM)).thenReturn("");
        mdcFilter.doFilter(req, resp, (req, rep) -> assertFalse(LoggingVariables.getTransactionId().isPresent()));
        assertFalse(LoggingVariables.getTransactionId().isPresent());
    }

    @Test
    public void handlesNoTransactionId() throws Exception {
        when(req.getParameter(TRANSACTION_ID_PARAM)).thenReturn(null);
        mdcFilter.doFilter(req, resp, (req, rep) -> assertFalse(LoggingVariables.getTransactionId().isPresent()));
        assertFalse(LoggingVariables.getTransactionId().isPresent());
    }

    @Test
    public void getsTransactionId() throws Exception {
        when(req.getParameter(TRANSACTION_ID_PARAM)).thenReturn("2678892");
        mdcFilter.doFilter(req, resp, (req, rep) -> assertEquals(TransactionId.instanceOf(2678892L), LoggingVariables.getTransactionId().get()));
    }

    @Test
    public void getsVerticalType() throws Exception {
        when(req.getParameter(VERTICAL_PARAM)).thenReturn("CAR");
        mdcFilter.doFilter(req, resp, (req, rep) -> assertEquals(CAR, LoggingVariables.getVerticalType().get()));
        assertFalse(LoggingVariables.getVerticalType().isPresent());
    }

    @Test
    public void handlesNoVerticalType() throws Exception {
        when(req.getParameter(VERTICAL_PARAM)).thenReturn(null);
        mdcFilter.doFilter(req, resp, (req, rep) -> assertEquals(GENERIC, LoggingVariables.getVerticalType().get()));
        assertFalse(LoggingVariables.getVerticalType().isPresent());
    }

    @Test
    public void handlesEmptyVerticalType() throws Exception {
        when(req.getParameter(VERTICAL_PARAM)).thenReturn("");
        mdcFilter.doFilter(req, resp, (req, rep) -> assertEquals(GENERIC, LoggingVariables.getVerticalType().get()));
        assertFalse(LoggingVariables.getVerticalType().isPresent());
    }

    @Test
    public void getsBrandCode() throws Exception {
        when(req.getParameter(BRAND_CODE_PARAM)).thenReturn("ctm");
        mdcFilter.doFilter(req, resp, (req, rep) -> assertEquals(BrandCode.instanceOf("ctm"), LoggingVariables.getBrandCode().get()));
        assertFalse(LoggingVariables.getBrandCode().isPresent());
    }

    @Test
    public void handlesNoBrandCode() throws Exception {
        when(req.getParameter(BRAND_CODE_PARAM)).thenReturn(null);
        mdcFilter.doFilter(req, resp, (req, rep) -> assertFalse(LoggingVariables.getBrandCode().isPresent()));
        assertFalse(LoggingVariables.getBrandCode().isPresent());
    }

}