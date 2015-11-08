package com.ctm.logging;

import ch.qos.logback.classic.spi.ILoggingEvent;
import com.ctm.services.EnvironmentService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.junit.Assert.assertEquals;
import static org.mockito.MockitoAnnotations.initMocks;

public class ServletContextConverterTest {
    @Mock
    private ILoggingEvent loggingEvent;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
    }

    @Test
    public void getsContextValue() throws Exception {
        final ServletContextConverter converter = new ServletContextConverter();

        EnvironmentService.setContextPath("ctm/");
        checkTransform(loggingEvent, "environment context", converter, "ctm/");
        EnvironmentService.setContextPath("ctm-BER-6");
        checkTransform(loggingEvent, "environment context", converter, "ctm-BER-6");
    }

    private void checkTransform(ILoggingEvent loggingEvent, final String message, final ServletContextConverter converter, final String expected) {
        final String transform = converter.transform(loggingEvent, "");
        assertEquals(message, expected, transform);
    }
}