package com.ctm.web.core.openinghours.api.model.request;

import com.ctm.web.core.model.formData.RequestImpl;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class OpeningHoursRequest extends RequestImpl {}
