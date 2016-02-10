package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.energy.quote.adapter.WebResponseAdapter;
import com.ctm.web.life.apply.response.LifeApplyWebResponseResults;
import com.ctm.web.life.apply.response.SelectDetails;
import com.ctm.web.life.apply.response.Selection;

import java.util.Map;

public class LifeApplyServiceResponseAdapter implements WebResponseAdapter<LifeApplyWebResponseResults.Builder, LifeApplyResponse> {

    @Override
    public LifeApplyWebResponseResults.Builder adapt(LifeApplyResponse applyResponse) {
        LifeApplyWebResponseResults.Builder builder= new LifeApplyWebResponseResults.Builder();
        Map<String, String> additionalInformation = applyResponse.getAdditionalInformation();
        if(!additionalInformation.isEmpty()) {
            SelectDetails client = new SelectDetails.Builder()
                    .info_url(applyResponse.getAdditionalInformation().get(LifeApplyResponse.PRIMARY_LIFEBROKER_INFO_URL))
                    .pds(applyResponse.getAdditionalInformation().get(LifeApplyResponse.PRIMARY_LIFEBROKER_PDS))
                    .build();
            SelectDetails partner = new SelectDetails.Builder()
                    .info_url(applyResponse.getAdditionalInformation().get(LifeApplyResponse.PARTNER_LIFEBROKER_INFO_URL))
                    .pds(applyResponse.getAdditionalInformation().get(LifeApplyResponse.PARTNER_LIFEBROKER_PDS))
                    .build();
            Selection selection = new Selection.Builder()
                    .client(client)
                    .partner(partner)
                    .build();
            builder.selection(selection);
        }
        builder.success(com.ctm.interfaces.common.types.Status.REGISTERED.equals(applyResponse.getResponseStatus()));
        return builder;
    }
}
