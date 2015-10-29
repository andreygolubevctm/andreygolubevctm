package com.ctm.logging;

import ch.qos.logback.classic.spi.ILoggingEvent;
import com.ctm.services.EnvironmentService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static java.util.Collections.singletonList;
import static org.junit.Assert.assertEquals;
import static org.mockito.MockitoAnnotations.initMocks;

public class EnvironmentConverterTest {
    @Mock
    private ILoggingEvent loggingEvent;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
    }

    @Test
    public void getsEnvironmentValue() throws Exception {
        final EnvironmentConverter converter = new EnvironmentConverter();
        checkTransform(loggingEvent, "empty value returns empty string", converter, "", "name");
        checkTransform(loggingEvent, "empty value returns empty string", converter, "", "context");
        checkTransform(loggingEvent, "empty value returns empty string", converter, "", "");

        EnvironmentService.setEnvironment("localhost");
        checkTransform(loggingEvent, "environment name", converter, "localhost", "name");
        EnvironmentService.setEnvironment("NXI");
        checkTransform(loggingEvent, "environment name", converter, "NXI", "name");

        EnvironmentService.setContextPath("ctm/");
        checkTransform(loggingEvent, "environment context", converter, "ctm/", "context");
        EnvironmentService.setContextPath("ctm-BER-6");
        checkTransform(loggingEvent, "environment context", converter, "ctm-BER-6", "context");
    }

    private void checkTransform(ILoggingEvent loggingEvent, final String message, final EnvironmentConverter converter, final String expected, final String code) {
        converter.setOptionList(singletonList(code));
        final String transform = converter.transform(loggingEvent, "");
        assertEquals(message, expected, transform);
    }
}