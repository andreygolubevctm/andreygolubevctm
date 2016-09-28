package com.ctm.web.energy.apply.model.response;

import com.ctm.apply.model.response.SingleApplyResponse;
import com.ctm.web.core.providers.model.IncomingApplyResponse;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class EnergyApplyResponse extends IncomingApplyResponse<SingleApplyResponse> {
}
