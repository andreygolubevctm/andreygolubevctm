package com.ctm.providers.home.homequote.model.request;

import java.time.LocalDate;

public class PreviousCover {

    private boolean atCurrentAddress;

    private String insurer;

    private LocalDate expiryDate;

    private int coverLength;

    public boolean isAtCurrentAddress() {
        return atCurrentAddress;
    }

    public void setAtCurrentAddress(boolean atCurrentAddress) {
        this.atCurrentAddress = atCurrentAddress;
    }

    public String getInsurer() {
        return insurer;
    }

    public void setInsurer(String insurer) {
        this.insurer = insurer;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getCoverLength() {
        return coverLength;
    }

    public void setCoverLength(int coverLength) {
        this.coverLength = coverLength;
    }
}
