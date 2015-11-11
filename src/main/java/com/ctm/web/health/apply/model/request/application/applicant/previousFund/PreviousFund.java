package com.ctm.web.health.apply.model.request.application.applicant.previousFund;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.ctm.web.health.apply.model.request.application.common.Authority;
import com.ctm.web.health.apply.model.request.fundData.HealthFund;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class PreviousFund {

    private final HealthFund fundName;

    @JsonSerialize(using = TypeSerializer.class)
    private final MemberId memberID;

    private final ConfirmCover confirmCover;

    private final Authority authority;

    public PreviousFund (final HealthFund fundName, final MemberId memberId, final ConfirmCover confirmCover, final Authority authority) {
        this.fundName = fundName;
        this.memberID = memberId;
        this.confirmCover = confirmCover;
        this.authority = authority;
    }

}
