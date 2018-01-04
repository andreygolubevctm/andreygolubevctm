package com.ctm.web.email.integration.emailservice;

public enum EmailTokenType {
    APP, BEST_PRICE, BROCHURES, EDM, PROMOTION, QUOTE, REMINDER_11_MONTH;

    public static EmailTokenType find(final String type) {
        for (final EmailTokenType t : EmailTokenType.values()) {
            if (type.equalsIgnoreCase(t.toString())) {
                return t;
            }
        }
        throw new IllegalArgumentException("Invalid token type");
    }
}
