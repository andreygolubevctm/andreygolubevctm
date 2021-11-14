package com.ctm.web.health.quote.model.request;

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
    BUD(54),
    NHB(17),
    HBF(18),
    QTU(19),
    QTS(462),
    MYO(20),
    HEA(456),
    CBA(30),
    UHF(463);

    private final int id;

    private HealthFund(final int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
