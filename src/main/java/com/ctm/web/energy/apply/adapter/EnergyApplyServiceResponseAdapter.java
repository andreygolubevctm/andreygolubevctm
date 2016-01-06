package com.ctm.web.energy.apply.adapter;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.ctm.web.energy.quote.adapter.WebResponseAdapter;

public class EnergyApplyServiceResponseAdapter  implements WebResponseAdapter<EnergyApplyWebResponseModel.EnergyApplyWebResponseModelBuilder, ApplyResponse> {

    @Override
    public EnergyApplyWebResponseModel.EnergyApplyWebResponseModelBuilder adapt(ApplyResponse applyResponse) {
        EnergyApplyWebResponseModel.EnergyApplyWebResponseModelBuilder builder= new EnergyApplyWebResponseModel.EnergyApplyWebResponseModelBuilder();
        builder.uniquePurchaseId(applyResponse.getConfirmationId().get());
        return builder;
    }
}