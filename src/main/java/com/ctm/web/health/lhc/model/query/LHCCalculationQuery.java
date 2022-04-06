package com.ctm.web.health.lhc.model.query;

import com.fasterxml.jackson.annotation.JsonInclude;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class LHCCalculationQuery {
    @Valid
    @NotNull
    private LHCCalculationDetails primary;
    @Valid
    private LHCCalculationDetails partner;

    public LHCCalculationQuery() { /* Intentionally Empty for Jackson deserialization. */ }

    public LHCCalculationDetails getPrimary() {
        return primary;
    }

    public void setPrimary(LHCCalculationDetails primary) {
        this.primary = primary;
    }

    public LHCCalculationQuery primary(LHCCalculationDetails primary) {
        setPrimary(primary);
        return this;
    }

    public LHCCalculationDetails getPartner() {
        return partner;
    }

    public void setPartner(LHCCalculationDetails partner) {
        this.partner = partner;
    }

    public LHCCalculationQuery partner(LHCCalculationDetails partner) {
        setPartner(partner);
        return this;
    }

}
