package com.ctm.web.life.apply.adapter;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.web.energy.quote.adapter.WebResponseAdapter;
import com.ctm.web.life.apply.response.LifeApplyWebResponseModel;

public class LifeApplyServiceResponseAdapter implements WebResponseAdapter<LifeApplyWebResponseModel.EnergyApplyWebResponseModelBuilder, ApplyResponse> {

    @Override
    public LifeApplyWebResponseModel.EnergyApplyWebResponseModelBuilder adapt(ApplyResponse applyResponse) {
        LifeApplyWebResponseModel.EnergyApplyWebResponseModelBuilder builder= new LifeApplyWebResponseModel.EnergyApplyWebResponseModelBuilder();
        builder.uniquePurchaseId(applyResponse.getConfirmationId().get());
        return builder;
    }
}
