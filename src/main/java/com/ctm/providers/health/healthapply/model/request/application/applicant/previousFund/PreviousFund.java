package com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund;

import com.ctm.healthapply.model.request.fundData.HealthFund;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Optional;

public class PreviousFund {

    public static final PreviousFund NONE = new PreviousFund();

    @JsonProperty("fundName")
    private HealthFund healthFund;

    @JsonProperty("memberID")
    private MemberId memberId;

    private ConfirmCover confirmCover;

    private Authority authority;

    public Optional<HealthFund> getHealthFund() {
        return Optional.ofNullable(healthFund);
    }

    public Optional<MemberId> getMemberId() {
        return Optional.ofNullable(memberId);
    }

    public Optional<Authority> getAuthority() {
        return Optional.ofNullable(authority);
    }

    public Optional<ConfirmCover> getConfirmCover() {
        return Optional.ofNullable(confirmCover);
    }

    @JsonProperty("memberID")
    private String memberId() {
        return memberId == null ? null : memberId.get();
    }

}
