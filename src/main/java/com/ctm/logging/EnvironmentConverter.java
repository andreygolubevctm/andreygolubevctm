package com.ctm.logging;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.pattern.CompositeConverter;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.services.EnvironmentService;

import java.util.Optional;

import static java.util.Optional.ofNullable;

public class EnvironmentConverter extends CompositeConverter<ILoggingEvent> {
    private static final String DEFAULT_VALUE = "";

    @Override
    protected String transform(ILoggingEvent loggingEvent, String s) {
        return ofNullable(getFirstOption()).map(this::value).orElse(DEFAULT_VALUE);
    }

    private String value(String code) {
        switch (code) {
            case "name":
                return environmentName().orElse(DEFAULT_VALUE);
            case "context":
                return EnvironmentService.getContextPath();
            default:
                return DEFAULT_VALUE;
        }
    }

    private Optional<String> environmentName() {
        try {
            return Optional.of(EnvironmentService.getEnvironment().toString());
        } catch (EnvironmentException e) {
            return Optional.empty();
        }
    }

}
