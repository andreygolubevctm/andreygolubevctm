package com.ctm.web.health.utils;

import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.request.BaseHealthRequest;
import com.ctm.web.core.services.RequestService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.validation.constraints.NotNull;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HealthRequestParser {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthRequestParser.class);

    @NotNull
    public static BaseHealthRequest getHealthRequestToken(RequestService requestService, boolean isCallCentre) {
        BaseHealthRequest healthRequest = new BaseHealthRequest();
        requestService.parseCommonValues(healthRequest);
        healthRequest.setIsCallCentre(isCallCentre);
        healthRequest.setToken(requestService.getToken());
        healthRequest.setTransactionId(requestService.getTransactionId());
        return healthRequest;
    }

    public static long getProductIdFromHealthRequest(final HealthRequest data) {
        long productId = 0;
        try {
            Optional<HealthQuote> quote = Optional.ofNullable(data.getHealth());
            if(quote.isPresent()) {
                Optional<Application> application = Optional.ofNullable(quote.get().getApplication());
                if(application.isPresent()) {
                    Optional<String> rawId = Optional.ofNullable(application.get().getProductId());
                    if(rawId.isPresent()) {
                        String id = rawId.get().replaceAll("\\D", "");
                        if(!id.isEmpty() && StringUtils.isNumeric(id)) {
                            productId = Long.parseLong(id);
                        } else {
                            throw new Exception("ProductId was empty or contained no numeric chars (" + id + ")");
                        }
                    } else {
                        throw new Exception("ProductId was null");
                    }
                } else {
                    throw new Exception("Application object was null");
                }
            } else {
                throw new Exception("HealthQuote object was null");
            }
        } catch(Exception e) {
            LOGGER.error("Failed to retrieve productId from HealthRequest: {} {}", kv("transactionId", data.getTransactionId()), kv("reason", e.getMessage()), e);
        }
        return productId;
    }
}
