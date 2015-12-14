package com.ctm.web.core.providers.model;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.interfaces.common.types.ConfirmationId;
import com.ctm.interfaces.common.types.PartnerError;
import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.interfaces.common.types.Status;

import java.util.List;


public class ApplyResponseImpl implements ApplyResponse {
    private ConfirmationId confirmationId;
    private Status responseStatus;
    private ServiceId service;
    private List<PartnerError> partnerErrorList;

    public void setConfirmationId(ConfirmationId confirmationId) {
        this.confirmationId = confirmationId;
    }

    public void setResponseStatus(Status responseStatus) {
        this.responseStatus = responseStatus;
    }

    public void setService(ServiceId service) {
        this.service = service;
    }

    public void setPartnerErrorList(List<PartnerError> partnerErrorList) {
        this.partnerErrorList = partnerErrorList;
    }

    @Override
    public ConfirmationId getConfirmationId() {
        return confirmationId;
    }

    @Override
    public Status getResponseStatus() {
        return responseStatus;
    }

    @Override
    public ServiceId getService() {
        return service;
    }

    @Override
    public List<PartnerError> getPartnerErrorList() {
        return partnerErrorList;
    }
}
