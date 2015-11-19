package com.ctm.web.core.logging.listeners;

import com.ctm.web.core.logging.LoggingVariables;
import org.junit.Test;
import org.slf4j.MDC;

import javax.servlet.FilterChain;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import static junit.framework.TestCase.assertFalse;
import static org.mockito.Mockito.mock;

public class MDCFilterTest {

    @Test
    public void testDoFilter() throws Exception {
        MDCFilter mdcFilter= new MDCFilter();
        ServletRequest req = mock(ServletRequest.class);
        ServletResponse resp = mock(ServletResponse.class);
        FilterChain chain = mock(FilterChain.class);
        mdcFilter.doFilter(req, resp, chain);
        assertFalse(String.valueOf(MDC.get(LoggingVariables.CORRELATION_ID_KEY)).isEmpty());

    }
}