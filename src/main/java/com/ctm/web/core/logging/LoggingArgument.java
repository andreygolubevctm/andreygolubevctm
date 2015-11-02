package com.ctm.web.core.logging;

import com.fasterxml.jackson.core.JsonGenerator;

import java.io.IOException;

/**
 * Represents a key value pair for inserting into a log statement.
 *
 * This mirrors the StructuredArgument class from logstash-logback-encoder to avoid a direct dependency on this library and on logback.
 */
public interface LoggingArgument {
    /**
     * Writes this arguments data to json using the supplied {@Link JsonGenerator}
     */
    void writeTo(JsonGenerator generator) throws IOException;

    /**
     * Write this arguments data to a {@link String}. This is used when using parameter substitution with log messages.
     */
    String toString();
}
