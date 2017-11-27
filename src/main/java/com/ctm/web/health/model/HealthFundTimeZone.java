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

    private final String timezone;
    private final ZoneId zoneId;

    HealthFundTimeZone(final String timezone) {
        this.timezone = timezone;
        this.zoneId = ZoneId.of(timezone);
    }

    public ZoneId get() {
        return this.zoneId;
    }

    public static HealthFundTimeZone getByCode(final String code) {
        if(code == null) {
            return null;
        }
        for (final HealthFundTimeZone fund : HealthFundTimeZone.values()) {
            if (code.equalsIgnoreCase(fund.name())) {
                return fund;
            }
        }
        return null;
    }

    public String getTimeZone() {
        return this.timezone;
    }
}
