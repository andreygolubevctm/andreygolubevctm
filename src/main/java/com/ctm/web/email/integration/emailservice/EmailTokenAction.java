package com.ctm.web.email.integration.emailservice;

public enum EmailTokenAction {
    LOAD, UNSUBSCRIBE, TOY_TRACKER, TOY_TRACKER_UNSUBSCRIBE, TOY_REDEMPTION;

    public static EmailTokenAction find(final String action) {
        for (final EmailTokenAction t : EmailTokenAction.values()) {
            if (action.equalsIgnoreCase(t.toString())) {
                return t;
            }
        }
        throw new IllegalArgumentException("Invalid token action");
    }
}
