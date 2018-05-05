package com.ctm.web.health.lhc.model.query;

import com.fasterxml.jackson.annotation.JsonInclude;

import javax.validation.constraints.NotNull;
import java.time.LocalDate;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class LHCBaseDateQuery {
    @NotNull
    private LocalDate primaryDOB;
    private LocalDate partnerDOB;

    public LocalDate getPrimaryDOB() {
        return primaryDOB;
    }

    public void setPrimaryDOB(LocalDate primaryDOB) {
        this.primaryDOB = primaryDOB;
    }

    public LHCBaseDateQuery primaryDOB(LocalDate primaryDOB) {
        setPrimaryDOB(primaryDOB);
        return this;
    }

    public LocalDate getPartnerDOB() {
        return partnerDOB;
    }

    public void setPartnerDOB(LocalDate partnerDOB) {
        this.partnerDOB = partnerDOB;
    }

    public LHCBaseDateQuery partnerDOB(LocalDate partnerDOB) {
        setPartnerDOB(partnerDOB);
        return this;
    }
}
