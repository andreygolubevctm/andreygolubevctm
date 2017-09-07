package com.ctm.life.apply.model.response;

import com.ctm.interfaces.common.types.ConfirmationId;
import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.interfaces.common.types.Status;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@JacksonXmlRootElement(
        localName = "response"
)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class LifeApplyResponse {

    public static final String PRIMARY_LIFEBROKER_PDS = "primary_pds";
    public static final String PRIMARY_LIFEBROKER_INFO_URL = "primary_info_url";
    public static final String PARTNER_LIFEBROKER_PDS = "partner_pds";
    public static final String PARTNER_LIFEBROKER_INFO_URL = "partner_info_url";

    private ConfirmationId confirmationId;
    private Status responseStatus;
    private Map<String, String> additionalInformation;
    private ServiceId service;

    protected LifeApplyResponse() {
    }

    protected LifeApplyResponse(Builder builder) {
        confirmationId = builder.confirmationId;
        responseStatus = builder.responseStatus;
        additionalInformation = builder.additionalInformation;
        service = builder.service;
    }

    @JsonSerialize(using = ValueSerializer.class)
    public ConfirmationId getConfirmationId() {
        return confirmationId;
    }

    @JsonSerialize(using = ValueSerializer.class)
    public ServiceId getService() {
        return service;
    }

    public Status getResponseStatus() {
        return responseStatus;
    }

    public Optional<Map<String, String>> getAdditionalInformation() {
        return Optional.ofNullable(additionalInformation);
    }

    public static class Builder<T extends LifeApplyResponse.Builder>  {
        private ServiceId service;
        private ConfirmationId confirmationId;
        private Status responseStatus;
        private Map<String, String> additionalInformation = new HashMap<>();

        public Builder() {
        }

        public T confirmationId(ConfirmationId val) {
            confirmationId = val;
             return (T) this;
        }

        public T responseStatus(Status val) {
            responseStatus = val;
            return (T) this;
        }

        public T additionalInformation(Map<String, String> val) {
            additionalInformation = val;
            return (T) this;
        }

        public  T  service(ServiceId val) {
            service = val;
            return (T) this;
        }

        public LifeApplyResponse build() {
            return new LifeApplyResponse(this);
        }

        public Builder<Builder> additionalInformation(String key, String value) {
            additionalInformation.put(key, value);
            return (T) this;
        }
    }
}