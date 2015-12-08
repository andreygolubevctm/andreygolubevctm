package com.ctm.web.health.router;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlCData;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;

import java.time.LocalDate;

@JacksonXmlRootElement(localName = "data")
public class ConfirmationData {

    private final String transID;

    private final String status = "OK";

    private final String vertical = "CTMH";

    @JsonSerialize(using = AUSLocalDateSerializer.class)
    private final LocalDate startDate;

    private final String frequency;

    @JacksonXmlCData
    private final String about;

    @JacksonXmlCData
    private final String whatsNext;

    @JacksonXmlCData
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

    public String getTransID() {
        return transID;
    }

    public String getStatus() {
        return status;
    }

    public String getVertical() {
        return vertical;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public String getFrequency() {
        return frequency;
    }

    public String getAbout() {
        return about;
    }

    public String getWhatsNext() {
        return whatsNext;
    }

    public String getProduct() {
        return product;
    }

    public String getPolicyNo() {
        return policyNo;
    }
}
