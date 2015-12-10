package com.ctm.web.energy.apply.adapter;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.ctm.web.energy.quote.adapter.WebResponseAdapter;

public class EnergyApplyServiceResponseAdapter  implements WebResponseAdapter<EnergyApplyWebResponseModel, ApplyResponse> {

    @Override
    public EnergyApplyWebResponseModel adapt(ApplyResponse applyResponse) {
        return null;
    }
}
