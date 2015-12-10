package com.ctm.web.energy.apply.adapter;

import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostReqestPayload;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;

/**
 * Created by lbuchanan on 30/11/2015.
 */
public class EnergyApplyServiceRequestAdapter implements WebRequestAdapter<EnergyApplyPostReqestPayload, EnergyApplicationDetails> {


    @Override
    public EnergyApplicationDetails adapt(EnergyApplyPostReqestPayload request) {
        return null;
    }
}
