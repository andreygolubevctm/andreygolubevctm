package com.ctm.providers.health.healthapply.model.request.fundData;

import com.ctm.providers.health.healthapply.model.request.fundData.benefits.Benefits;
import com.ctm.providers.health.healthapply.model.request.payment.details.StartDate;

public class FundData {

    private final FundCode fundCode;

    private final HospitalCoverName hospitalCoverName;

    private final ExtrasCoverName extrasCoverName;

    private final Provider provider;

    private final ProductId product;

    private final Declaration declaration;

    private final StartDate startDate;

    private final Benefits benefits;

    public FundData(final FundCode fundCode, final HospitalCoverName hospitalCoverName,
                    final ExtrasCoverName extrasCoverName, final Provider provider, final ProductId product,
                    final Declaration declaration, final StartDate startDate, final Benefits benefits) {
        this.fundCode = fundCode;
        this.hospitalCoverName = hospitalCoverName;
        this.extrasCoverName = extrasCoverName;
        this.provider = provider;
        this.product = product;
        this.declaration = declaration;
        this.startDate = startDate;
        this.benefits = benefits;
    }
}
