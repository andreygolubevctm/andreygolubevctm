package com.ctm.providers.health.healthapply.model.response;

import com.ctm.providers.Response;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class HealthApplyResponse extends Response<HealthApplicationResponse> {

}
