package com.ctm.apply.model.response;

import com.ctm.interfaces.common.types.ConfirmationId;
import com.ctm.interfaces.common.types.PartnerError;
import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.interfaces.common.types.Status;

import java.util.List;

public interface ApplyResponse {
    ConfirmationId getConfirmationId();

    Status getResponseStatus();

    ServiceId getService();

    List<PartnerError> getPartnerErrorList();
}
