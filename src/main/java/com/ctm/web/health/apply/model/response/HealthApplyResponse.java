package com.ctm.web.health.apply.model.response;

import com.ctm.web.core.providers.model.Response;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class HealthApplyResponse extends Response<HealthApplicationResponse> {

}
