package com.ctm.web.energy.apply.adapter;

import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;

/**
 * Created by lbuchanan on 30/11/2015.
 */
public class EnergyApplyServiceRequestAdapter implements WebRequestAdapter<EnergyApplyPostRequestPayload, EnergyApplicationDetails> {


    @Override
    public EnergyApplicationDetails adapt(EnergyApplyPostRequestPayload request) {
        return null;
    }
}
