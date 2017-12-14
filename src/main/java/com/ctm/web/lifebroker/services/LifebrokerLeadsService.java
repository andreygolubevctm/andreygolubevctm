package com.ctm.web.lifebroker.services;


import com.ctm.web.lifebroker.model.LifebrokerLeadRequest;
import com.ctm.web.lifebroker.model.LifebrokerLeadResponse;
import com.ctm.web.lifebroker.model.LifebrokerLeadResults;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.web.client.AsyncRestTemplate;

import java.nio.charset.Charset;
import java.util.Collections;
import java.util.concurrent.TimeUnit;


/**
 * Created by msmerdon on 04/12/2017.
 */
@Service
public class LifebrokerLeadsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifebrokerLeadsService.class);

    @Value("${lifebroker.lead.endpoint}")
    private String endpoint;

    @Value("${lifebroker.lead.username}")
    private String username;

    @Value("${lifebroker.lead.password}")
    private String password;

    @Value("${lifebroker.lead.mediaCode:CTMREF01}")
    private String mediaCode;

    @Value("${lifebroker.lead.timeout:10}")
    private Long timeout;

    @Autowired
    private AsyncRestTemplate asyncRestTemplate;

    public static final String BASIC_AUTHORIZATION_PREFIX = "Basic ";
    public static final String AUTHORIZATION_HEADER = "Authorization";

    HttpHeaders getHeaders() {
        return new HttpHeaders() {{
            String auth = username + ":" + password;
            byte[] encodedAuth = Base64.encodeBase64(
                    auth.getBytes(Charset.forName("US-ASCII")));
            String authorizationHeader = BASIC_AUTHORIZATION_PREFIX + new String(encodedAuth);
            set(AUTHORIZATION_HEADER, authorizationHeader);
            setContentType(MediaType.TEXT_XML);
            setAccept(Collections.singletonList(MediaType.APPLICATION_XML));
        }};
    }

    public LifebrokerLeadResponse getLeadResponse(final String transactionId, final String email, final String phone, final String postcode, final String name, final String callTime) {
        try {
            final LifebrokerLeadRequest lifebrokerLeadRequest = new LifebrokerLeadRequest(transactionId, email, phone, postcode, name, mediaCode, callTime);
            HttpHeaders headers = getHeaders();
            HttpEntity<LifebrokerLeadRequest> lifebrokerLeadRequestEntity = new HttpEntity<LifebrokerLeadRequest>(lifebrokerLeadRequest, headers);
            ListenableFuture<ResponseEntity<LifebrokerLeadResults>> listenableFuture = asyncRestTemplate.exchange(endpoint, HttpMethod.POST, lifebrokerLeadRequestEntity, LifebrokerLeadResults.class);
            final ResponseEntity<LifebrokerLeadResults> lifebrokerLeadResultsEntity = listenableFuture.get(timeout, TimeUnit.SECONDS);
            final LifebrokerLeadResults lifebrokerLeadResults = lifebrokerLeadResultsEntity.getBody();
            if (lifebrokerLeadResults.getContact() == null) {
                return new LifebrokerLeadResponse().withClientReference(lifebrokerLeadResults.getClient().getReference());
            }
            return new LifebrokerLeadResponse().withMessage(lifebrokerLeadResults.getContact().getError());
        } catch (Exception e) {
            LOGGER.error("Exception occured getting Lifebroker lead: {}", e.getMessage(), e);
            return new LifebrokerLeadResponse().withMessage(e.getMessage());
        }
    }


}
