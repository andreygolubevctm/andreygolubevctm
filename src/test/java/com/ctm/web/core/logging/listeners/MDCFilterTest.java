package com.ctm.web.core.logging.listeners;

import com.ctm.commonlogging.context.LoggingVariables;
import org.junit.Test;

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
        assertFalse(LoggingVariables.getCorrelationId().toString().isEmpty());
    }
}