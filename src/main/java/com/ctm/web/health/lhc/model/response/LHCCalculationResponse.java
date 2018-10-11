package com.ctm.web.health.lhc.model.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.Optional;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class LHCCalculationResponse {

    private LHCCalculation primary;
    private Optional<LHCCalculation> partner;
    private Optional<LHCCalculation> combined;

    public LHCCalculationResponse(LHCCalculation primary, Optional<LHCCalculation> partner) {
        this.primary = primary;
        this.partner = partner;
        this.combined = partner.map(c -> (c.getLhcPercentage() + primary.getLhcPercentage()) / 2).map(LHCCalculation::new);
    }

    public LHCCalculation getPrimary() {
        return primary;
    }

    public Optional<LHCCalculation> getPartner() {
        return partner;
    }

    public Optional<LHCCalculation> getCombined() {
        return combined;
    }
}
