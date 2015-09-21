package com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.ctm.providers.health.healthapply.model.request.fundData.HealthFund;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

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
