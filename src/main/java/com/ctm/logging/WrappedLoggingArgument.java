package com.ctm.logging;

import com.fasterxml.jackson.core.JsonGenerator;
import net.logstash.logback.argument.StructuredArgument;

import java.io.IOException;

/**
 * Adapts the logstash-logback-encoder {@link StructuredArgument} to a {@link @LoggingArgument}
 */
class WrappedLoggingArgument implements LoggingArgument, StructuredArgument {
    private StructuredArgument structuredArgument;

    private WrappedLoggingArgument(final StructuredArgument structuredArgument) {
        this.structuredArgument = structuredArgument;
    }

    public static WrappedLoggingArgument wrappedLoggingArgument(final StructuredArgument structuredArgument) {
        return new WrappedLoggingArgument(structuredArgument);
    }

    @Override
    public void writeTo(final JsonGenerator generator) throws IOException {
        structuredArgument.writeTo(generator);
    }

    @Override
    public String toString() {
        return structuredArgument.toString();
    }
}
