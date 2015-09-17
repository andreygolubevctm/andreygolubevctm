package com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund;

import com.ctm.providers.health.healthapply.model.request.fundData.HealthFund;

public class PreviousFund {

    private final HealthFund fundName;

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
