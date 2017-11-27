package com.ctm.web.health.model;

import java.time.ZoneId;

public enum HealthFundTimeZone {

    AHM("Australia/Victoria"),
    AUF("Australia/Victoria"),
    BUD("Australia/Victoria"),
    BUP("Australia/Victoria"),
    CBH("Australia/NSW"),
    CTM("Australia/Queensland"),
    CUA("Australia/Queensland"),
    FRA("Australia/Victoria"),
    GMH("Australia/Victoria"),
    HBF("Australia/West"),
    HCF("Australia/NSW"),
    HIF("Australia/Queensland"),
    MYO("Australia/Victoria"),
    NHB("Australia/Victoria"),
    NIB("Australia/NSW"),
    QCH("Australia/Queensland"),
    QTU("Australia/Queensland"),
    WFD("Australia/NSW"),
    DEFAULT("Australia/Queensland");

    private final ZoneId timezone;

    HealthFundTimeZone(final String timezone) {
        this.timezone = ZoneId.of(timezone);
    }

    public ZoneId get() {
        return timezone;
    }

    public static ZoneId getByCode(final String code) {
        if(code == null) {
            return null;
        }
        for (final HealthFundTimeZone fund : HealthFundTimeZone.values()) {
            if (code.equalsIgnoreCase(fund.name())) {
                return fund.get();
            }
        }
        return null;
    }
}
