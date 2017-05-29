package com.ctm.apply.model.response;

import com.ctm.interfaces.common.types.*;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;

import java.util.List;

@JacksonXmlRootElement(
        localName = "response"
)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class SingleApplyResponse implements  ApplyResponse {

    private String confirmationId;

    private Status responseStatus;

    private String service;

    private List<PartnerError> partnerErrorList;
    private List<ResponseError> errorList;

    private SingleApplyResponse(Builder builder) {
        confirmationId = builder.confirmationId;
        responseStatus = builder.status;
        service = builder.service;
        partnerErrorList = builder.partnerErrorList;
        errorList = builder.errorList;
    }

    private SingleApplyResponse() {
    }

    @JsonSerialize(using = ValueSerializer.class)
    @Override
    public ConfirmationId getConfirmationId() {
        return ConfirmationId.instanceOf(confirmationId);
    }

    @Override
    public Status getResponseStatus() {
        return responseStatus;
    }

    @JsonSerialize(using = ValueSerializer.class)
    @Override
    public ServiceId getService() {
        return ServiceId.instanceOf(service);
    }

    @Override
    public List<PartnerError> getPartnerErrorList() {
        return partnerErrorList;
    }

    public List<ResponseError> getErrorList() {
        return errorList;
    }


    public static final class Builder {
        private String confirmationId;
        private Status status;
        private String service;
        private List<PartnerError> partnerErrorList;
        private List<ResponseError> errorList;

        public Builder() {
        }

        public Builder confirmationId(ConfirmationId val) {
            confirmationId = val.get();
            return this;
        }

        public Builder responseStatus(Status val) {
            status = val;
            return this;
        }

        public Builder service(ServiceId val) {
            service = val.get();
            return this;
        }

        public Builder partnerErrorList(List<PartnerError> val) {
            partnerErrorList = val;
            return this;
        }

        public Builder errorList(List<ResponseError> val) {
            errorList = val;
            return this;
        }

        public SingleApplyResponse build() {
            return new SingleApplyResponse(this);
        }
    }
}