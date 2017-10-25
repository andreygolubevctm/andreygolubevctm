package com.ctm.web.health.services;

import com.ctm.web.core.leadService.model.CliReturnRequest;
import com.ctm.web.core.leadService.model.LeadOutcome;
import com.ctm.web.core.leadService.services.LeadServiceUtil;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.health.simples.model.CliReturn;
import com.ctm.web.health.simples.model.CliReturnResponse;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.concurrent.ListenableFuture;

import java.util.Optional;
import java.util.concurrent.TimeUnit;

import static com.ctm.web.health.services.HealthCallBackService.HEALTH_VERTICAL_ID;
import static com.ctm.web.health.services.HealthCallBackService.LEAD_SERVICE_TIMEOUT;

@Component
public class HealthSimplesLeadService {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthSimplesLeadService.class);


    public CliReturnResponse sendCliReturnNote(CliReturn data) throws Exception {
        final ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("leadService", HEALTH_VERTICAL_ID);

        final Boolean enabled = Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", 0, 0, ServiceConfigurationProperty.Scope.SERVICE));
        final String url = serviceConfig.getPropertyValueByKey("url", 0, 0, ServiceConfigurationProperty.Scope.SERVICE) + "cliReturn";

        if (enabled) {
            final ListenableFuture<ResponseEntity<LeadOutcome>> sendRequestListenable = LeadServiceUtil.sendCliReturnRequest(new CliReturnRequest(data.getValue(), data.getStyleCodeId()), url);

            final ResponseEntity<LeadOutcome> responseEntity = sendRequestListenable.get(LEAD_SERVICE_TIMEOUT, TimeUnit.SECONDS);
            final CliReturnResponse response = createResponse(responseEntity);
            LOGGER.info("CliReturn phoneNumber {} response {}", data, response);
            return response;
        }

        LOGGER.info("LeadService is disabled");
        return new CliReturnResponse("success");
    }

    private CliReturnResponse createResponse(ResponseEntity<LeadOutcome> responseEntity) {
        final LeadOutcome outcome = Optional.ofNullable(responseEntity.getBody()).orElse(LeadOutcome.FAIL);
        return new CliReturnResponse(StringUtils.lowerCase(outcome.name()));
    }

}
