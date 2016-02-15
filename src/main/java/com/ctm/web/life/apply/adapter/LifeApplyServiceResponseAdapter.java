package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.energy.quote.adapter.WebResponseAdapter;
import com.ctm.web.life.apply.response.LifeApplyWebResponseResults;
import com.ctm.web.life.apply.response.SelectDetails;
import com.ctm.web.life.apply.response.Selection;

import java.util.Map;
import java.util.Optional;

public class LifeApplyServiceResponseAdapter implements WebResponseAdapter<LifeApplyWebResponseResults.Builder, LifeApplyResponse> {

    @Override
    public LifeApplyWebResponseResults.Builder adapt(LifeApplyResponse applyResponse) {
        LifeApplyWebResponseResults.Builder builder= new LifeApplyWebResponseResults.Builder();
        Selection.Builder selectionBuilder = new Selection.Builder();
        Optional<Map<String, String>> additionalInformationMaybe = applyResponse.getAdditionalInformation();
        additionalInformationMaybe.ifPresent(additionalInformation -> {
            if(!additionalInformation.containsKey(LifeApplyResponse.PRIMARY_LIFEBROKER_INFO_URL)) {
                SelectDetails client = new SelectDetails.Builder()
                        .info_url(additionalInformation.get(LifeApplyResponse.PRIMARY_LIFEBROKER_INFO_URL))
                        .pds(additionalInformation.get(LifeApplyResponse.PRIMARY_LIFEBROKER_PDS))
                        .build();
                selectionBuilder.client(client);
            }
            if(!additionalInformation.containsKey(LifeApplyResponse.PARTNER_LIFEBROKER_INFO_URL)) {
                SelectDetails partner = new SelectDetails.Builder()
                        .info_url(additionalInformation.get(LifeApplyResponse.PARTNER_LIFEBROKER_INFO_URL))
                        .pds(additionalInformation.get(LifeApplyResponse.PARTNER_LIFEBROKER_PDS))
                        .build();
                selectionBuilder.partner(partner);
            }
            builder.selection(selectionBuilder.build());
        });
        builder.success(com.ctm.interfaces.common.types.Status.REGISTERED.equals(applyResponse.getResponseStatus()));
        return builder;
    }
}
