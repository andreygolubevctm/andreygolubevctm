package com.ctm.web.health.apply.model.request.payment.details;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum PaymentType {

    BANK("ba"),
    CREDIT_CARD("cc");

    private final String code;

    PaymentType(final String code) {
        this.code = code;
    }

    @JsonValue
    public String getCode() {
        return code;
    }

    @JsonCreator
    public static PaymentType findByCode(final String code) {
        for (final PaymentType t : PaymentType.values()) {
            if (code.equalsIgnoreCase(t.getCode())) {
                return t;
            }
        }
        return null;
    }

    public static PaymentType fromValue(final String v) {
        return findByCode(v);
    }
}
