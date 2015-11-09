package com.ctm.web.core.logging;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.pattern.CompositeConverter;
import com.ctm.web.core.services.EnvironmentService;

public class ServletContextConverter extends CompositeConverter<ILoggingEvent> {

    @Override
    protected String transform(ILoggingEvent loggingEvent, String s) {
        return EnvironmentService.getContextPath();
    }

}
