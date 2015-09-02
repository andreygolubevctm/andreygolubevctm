package com.ctm.providers.health.healthquote.model.request;

public enum HealthFund {

    AUF(1),
    HCF(2),
    NIB(3),
    AHM(9),
    GMH(5),
    WFD(7),
    FRA(8),
    CBH(10),
    HIF(11),
    CUA(12),
    CTM(14),
    BUP(15),
    QCH(16),
    BUD(54);

    private final int id;

    private HealthFund(final int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
