package com.ctm.web.core.leadService.services;

import com.ctm.web.core.leadService.model.CliReturnRequest;
import com.ctm.web.core.leadService.model.DelayLeadRequest;
import com.ctm.web.core.leadService.model.LeadOutcome;
import com.ctm.web.core.leadService.model.LeadRequest;
import com.ctm.web.core.leadService.model.LeadResponse;
import com.ctm.web.core.utils.ObjectMapperUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.web.client.AsyncRestTemplate;

import java.net.URI;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class LeadServiceUtil {
    private static final Logger LOGGER = LoggerFactory.getLogger(LeadServiceUtil.class);

    private static AsyncRestTemplate restTemplate;

    static {
        restTemplate = new AsyncRestTemplate();

        List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();
        MappingJackson2HttpMessageConverter jsonMessageConverter = new MappingJackson2HttpMessageConverter();
        jsonMessageConverter.setObjectMapper(ObjectMapperUtil.getObjectMapper());
        messageConverters.add(jsonMessageConverter);
        restTemplate.setMessageConverters(messageConverters);
    }

    public static ListenableFuture<ResponseEntity<LeadResponse>> sendRequestListenable(final LeadRequest leadData, final String url) {
        LOGGER.info("Sending request to LeadService {}", leadData);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<LeadRequest> entity = new HttpEntity<>(leadData, headers);

        return restTemplate.postForEntity(URI.create(url), entity, LeadResponse.class);
    }

    public static void sendRequest(final LeadRequest leadData, final String url) {
        ListenableFuture<ResponseEntity<LeadResponse>> listenable = sendRequestListenable(leadData, url);
        listenable.addCallback(new ListenableFutureCallback<ResponseEntity<LeadResponse>>() {
            @Override
            public void onFailure(Throwable throwable) {
                LOGGER.error("Failed sending lead request {}", kv("lead", leadData), throwable);
            }

            @Override
            public void onSuccess(ResponseEntity<LeadResponse> leadResponseResponseEntity) {
                LOGGER.info("Response from LeadService {}", kv("salesForceId", leadResponseResponseEntity.getBody().getSalesforceId()));
            }
        });
    }

    public static ListenableFuture<ResponseEntity<LeadOutcome>> sendCliReturnRequest(final CliReturnRequest request, final String url) {
        LOGGER.info("Sending request to LeadService {}", request);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<CliReturnRequest> entity = new HttpEntity<>(request, headers);

        return restTemplate.postForEntity(URI.create(url), entity, LeadOutcome.class);
    }

    public static ListenableFuture<ResponseEntity<LeadOutcome>> sendDelayLeadRequest(final DelayLeadRequest request, final String url) {
        LOGGER.info("Sending request to LeadService {}", request);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<DelayLeadRequest> entity = new HttpEntity<>(request, headers);

        return restTemplate.postForEntity(URI.create(url), entity, LeadOutcome.class);
    }
}
