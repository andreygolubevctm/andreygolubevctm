package com.ctm.logging;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.pattern.CompositeConverter;
import com.ctm.services.EnvironmentService;

public class ServletContextConverter extends CompositeConverter<ILoggingEvent> {

    @Override
    protected String transform(ILoggingEvent loggingEvent, String s) {
        return EnvironmentService.getContextPath();
    }

}
