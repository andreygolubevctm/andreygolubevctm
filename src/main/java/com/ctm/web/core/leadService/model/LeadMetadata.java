package com.ctm.web.core.leadService.model;

import com.ctm.web.health.model.leadservice.HealthMetadata;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

@JsonTypeInfo(use=JsonTypeInfo.Id.NAME, include=JsonTypeInfo.As.PROPERTY, property="@type")
@JsonSubTypes({@JsonSubTypes.Type(value = HealthMetadata.class, name = "health")})
public abstract class LeadMetadata {
    public abstract String getValues();
}
