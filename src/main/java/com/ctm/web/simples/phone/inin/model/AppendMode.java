package com.ctm.web.simples.phone.inin.model;

import org.codehaus.jackson.annotate.JsonValue;

/**
 * Represents a type of appender required at ICWS (Interaction Center Web Services)
 * end to separate a list of key-values pair for below end-point:
 * /icws/{sessionId}/interactions/{interactionId}
 *
 * APPEND - Append without any separator
 * APPEND_WITH_SEPARATOR - Append with a pipe separator
 */

public enum AppendMode {
    APPEND(1),
    APPEND_WITH_SEPARATOR(2);

    private final int value;

    AppendMode(final int value) {
        this.value = value;
    }

    @JsonValue
    public int value() {
        return value;
    }
}
