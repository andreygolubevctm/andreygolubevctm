package com.ctm.web.health.apply.model.request.application.applicant.previousFund;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.ctm.web.health.apply.model.request.application.common.Authority;
import com.ctm.web.health.apply.model.request.fundData.HealthFund;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class PreviousFund {

    private final HealthFund fundName;

    @JsonSerialize(using = TypeSerializer.class)
    private final MemberId memberID;

    private final ConfirmCover confirmCover;

    private final Authority authority;

    // Note. Named "coverType" internally as to not conflict with any properties called "type"
    @JsonProperty("type")
    private final CoverType coverType;

    // Note. For some reason Jackson marshalls this as "CancelOption" instead of "cancel", not sure why but that's why we specify the @JsonProperty decorator
    @JsonProperty("cancel")
    private final CancelOption cancel;

    public PreviousFund (final HealthFund fundName, final MemberId memberId, final ConfirmCover confirmCover, final Authority authority, final CoverType coverType, final CancelOption cancel) {
        this.fundName = fundName;
        this.memberID = memberId;
        this.confirmCover = confirmCover;
        this.authority = authority;
        this.coverType = coverType;
        this.cancel = cancel;
    }

    public HealthFund getFundName() {
        return fundName;
    }

    public MemberId getMemberID() {
        return memberID;
    }

    public ConfirmCover getConfirmCover() {
        return confirmCover;
    }

    public Authority getAuthority() {
        return authority;
    }

    public Optional<CoverType> getCoverType() { return Optional.ofNullable(coverType); }

    public Optional<CancelOption> getCancel() { return Optional.ofNullable(cancel); }
}
