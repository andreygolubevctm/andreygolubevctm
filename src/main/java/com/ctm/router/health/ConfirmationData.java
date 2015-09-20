package com.ctm.router.health;

import java.time.LocalDate;

public class ConfirmationData {

    private final String transID;

    private final String status = "OK";

    private final String vertical = "CTMH";

    private final LocalDate startDate;

    private final String frequency;

    private final String about;

    private final String whatsNext;

    private final String product;

    private final String policyNo;

    public ConfirmationData(String transID, LocalDate startDate, String frequency, String about, String whatsNext, String product, String policyNo) {
        this.transID = transID;
        this.startDate = startDate;
        this.frequency = frequency;
        this.about = about;
        this.whatsNext = whatsNext;
        this.product = product;
        this.policyNo = policyNo;
    }
}
