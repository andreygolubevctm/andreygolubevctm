package com.ctm.web.health.quote.model.request;

import java.time.LocalDate;

public class AbdSummary {
    private int abd;
    private int rabd;
    private LocalDate assessmentDate;
    private AbdDetails primary;
    private AbdDetails partner;

    public int getAbd() {
        return abd;
    }

    public void setAbd(int abd) {
        this.abd = abd;
    }

    public int getRabd() {
        return rabd;
    }

    public void setRabd(int rabd) {
        this.rabd = rabd;
    }

    public LocalDate getAssessmentDate() {
        return assessmentDate;
    }

    public void setAssessmentDate(LocalDate assessmentDate) {
        this.assessmentDate = assessmentDate;
    }

    public AbdDetails getPrimary() {
        return primary;
    }

    public void setPrimary(AbdDetails primary) {
        this.primary = primary;
    }

    public AbdDetails getPartner() {
        return partner;
    }

    public void setPartner(AbdDetails partner) {
        this.partner = partner;
    }
}
