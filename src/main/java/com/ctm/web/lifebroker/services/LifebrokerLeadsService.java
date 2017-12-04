package com.ctm.web.lifebroker.services;

import com.ctm.web.lifebroker.model.LifebrokerLead;
import com.ctm.web.lifebroker.model.LifebrokerLeadOutcome;
import com.ctm.web.lifebroker.services.LifebrokerLeadsServiceUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.concurrent.ListenableFuture;

import java.util.Optional;
import java.util.concurrent.TimeUnit;

/**
 * Created by msmerdon on 04/12/2017.
 */
@Service
public class LifebrokerLeadsService {
    private static final Logger LOGGER = LoggerFactory.getLogger(LifebrokerLeadsService.class);
    public static final String LIFEBROKER_URL = "https://enterpriseapi.lifebroker.com.au/2-7-0/lead/new";
    public static final int REQUEST_TIMEOUT = 10;

    public String sendLead(final String transactionId, final String email, final String phone, final String postcode, final String name, final String call_time) throws Exception {
        LifebrokerLead lifebrokerLead = new LifebrokerLead(transactionId, email, phone, postcode, name, call_time);


        final ListenableFuture<ResponseEntity<LifebrokerLeadOutcome>> sendRequestListenable = LifebrokerLeadsServiceUtil.sendLifebrokerLeadRequest(lifebrokerLead, LIFEBROKER_URL);

        final ResponseEntity<LifebrokerLeadOutcome> responseEntity = sendRequestListenable.get(REQUEST_TIMEOUT,
                TimeUnit.SECONDS);
        LOGGER.debug(responseEntity.getBody());
        final CliReturnResponse response = createResponse(responseEntity);
        LOGGER.info("CliReturn phoneNumber {} response {}", data, response);
        return response;
    }

    private CliReturnResponse createResponse(ResponseEntity<LifebrokerLeadOutcome> responseEntity) {
        final LifebrokerLeadOutcome outcome = Optional.ofNullable(responseEntity.getBody()).orElse(LifebrokerLeadOutcome.FAIL);
        return new CliReturnResponse(StringUtils.lowerCase(outcome.name()));
    }
}
