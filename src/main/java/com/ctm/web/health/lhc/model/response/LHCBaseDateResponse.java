package com.ctm.web.health.lhc.model.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.Optional;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public final class LHCBaseDateResponse {
    private final LHCBaseDateDetails primary;
    private final Optional<LHCBaseDateDetails> partner;

    public LHCBaseDateResponse(LHCBaseDateDetails primary, Optional<LHCBaseDateDetails> partner) {
        this.primary = primary;
        this.partner = partner;
    }

    public LHCBaseDateDetails getPrimary() {
        return primary;
    }

    public Optional<LHCBaseDateDetails> getPartner() {
        return partner;
    }
}
