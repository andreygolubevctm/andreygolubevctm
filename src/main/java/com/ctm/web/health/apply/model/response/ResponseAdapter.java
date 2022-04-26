package com.ctm.web.health.apply.model.response;

import com.ctm.schema.health.v1_0_0.ApplyResponse;
import org.springframework.http.HttpStatus;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class ResponseAdapter {

    private static final String SUCCESS_MESSAGE = "Success";

    public static HealthApplyResponse adapt(long transactionId, ApplyResponse schematicApplyResponse) {
        final HealthApplyResponse response = new HealthApplyResponse();
        response.setTransactionId(transactionId);
        response.setPayload(getHealthApplicationResponse(schematicApplyResponse));
        return response;
    }

    private static HealthApplicationResponse getHealthApplicationResponse(final ApplyResponse schematicApplyResponse) {
        final HealthApplicationResponse healthApplicationResponse = new HealthApplicationResponse();
        healthApplicationResponse.setSuccess(Optional.ofNullable(schematicApplyResponse.getMessage())
                .filter(SUCCESS_MESSAGE::equals)
                .map(message -> Status.Success)
                .orElse(Status.Fail));
        healthApplicationResponse.setFundId(Optional.ofNullable(schematicApplyResponse.getProviderCode()).orElse(null));
        healthApplicationResponse.setProductId(Optional.ofNullable(schematicApplyResponse.getPartnerReference()).orElse(null));
        healthApplicationResponse.setBccEmail(Optional.ofNullable(schematicApplyResponse.getBccEmailAddress()).orElse(null));
        healthApplicationResponse.setErrorList(getPartnerErrors(schematicApplyResponse));

        return healthApplicationResponse;
    }

    private static List<PartnerError> getPartnerErrors(final ApplyResponse schematicApplyResponse) {
        return Optional.ofNullable(schematicApplyResponse.getErrors())
                .orElse(Collections.emptyList())
                .stream()
                .filter(pe -> !pe.getMessage().isEmpty())
                .map(pe -> new PartnerError(pe.getMessage()))
                .collect(Collectors.toList());
    }
}
