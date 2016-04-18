package com.ctm.web.simples.phone.inin.model;

import com.fasterxml.jackson.annotation.JsonValue;

public enum SecurePauseType {
    PAUSE_WITH_DEFAULT_TIMEOUT(1),
    PAUSE_WITH_INFINITE_TIMEOUT(2),
    PAUSE_WITH_SPECIFIED_TIMEOUT(3),
    RESUME_RECORDING(4);

    private final int value;

    SecurePauseType(final int value) {
        this.value = value;
    }

    @JsonValue
    public int value() {
        return value;
    }
}
