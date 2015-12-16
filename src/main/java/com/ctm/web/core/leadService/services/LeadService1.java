package com.ctm.web.core.leadService.services;

import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadService.model.LeadRequest;
import com.ctm.web.core.leadService.model.LeadResponse;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.core.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.HttpClients;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public abstract class LeadService1 {
    private static final Logger LOGGER = LoggerFactory.getLogger(LeadService1.class);
    public static final String LAST_LEAD_SERVICE_VALUES = "LAST_LEAD_SERVICE_VALUES";

    private String url;
    private Boolean enabled;
    private TouchDao touchDao = new TouchDao();

    private static final String HTTP_PROXY_USER = "http.proxyUser";
    private static final String HTTP_PROXY_PASSWORD = "http.proxyPassword";
    private static final String HTTPS_PROXY_USER = "https.proxyUser";
    private static final String HTTPS_PROXY_PASSWORD = "https.proxyPassword";

    /**
     * Determines if we have the fields required for sending
     * @return
     * @param leadData
     */
    private boolean canSend(final LeadRequest leadData) {
        if(StringUtils.isEmpty(leadData.getSource())) {
            return false;
        }
        if(leadData.getRootId() == null) {
            return false;
        }
        if(leadData.getTransactionId() == null) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getBrandCode())) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getVerticalType())) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getClientIP())) {
            return false;
        }
        if(leadData.getStatus() == null) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getPerson().getFirstName())) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getPerson().getEmail())) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getPerson().getPhone()) && StringUtils.isEmpty(leadData.getPerson().getMobile())) {
            return false;
        }
        return true;
    }

    /**
     * Restfully sends the collected lead data to the CtM API endpoint
     */
    public void sendLead(final int verticalId, final Data data, final HttpServletRequest request) {
        try {
            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("leadService", verticalId, 0);

            this.enabled = Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", 0, 0, ServiceConfigurationProperty.Scope.SERVICE));
            this.url = serviceConfig.getPropertyValueByKey("url", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);
        } catch(DaoException | ServiceConfigurationException e) {
            LOGGER.error("Could not initialize Lead Service configuration {}", e);
        }

        if(enabled) {
            LeadRequest leadData = updatePayloadData(data);

            leadData.setSource("SECURE");
            leadData.setRootId(data.getLong("current/rootId"));
            leadData.setTransactionId(data.getLong("current/transactionId"));
            leadData.setBrandCode(data.getString("current/brandCode"));

            try {
                leadData.setStatus(touchDao.getTransactionStatus(leadData.getTransactionId()));
            } catch (DaoException e) {
                LOGGER.error("Could not query transaction status {}", kv("transactionId", leadData.getTransactionId()), e);
            }

            leadData.setClientIP(request.getRemoteAddr());

            String previousValues = (String) request.getSession().getAttribute(LAST_LEAD_SERVICE_VALUES);
            String currentValues = leadData.getValues();

            if(canSend(leadData) && !currentValues.equals(previousValues)) {
                request.getSession().setAttribute(LAST_LEAD_SERVICE_VALUES, currentValues);

                LOGGER.info("Sending request to LeadService {}", leadData);

                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_JSON);
                headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
                HttpEntity<LeadRequest> entity = new HttpEntity<>(leadData, headers);
                List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();
                MappingJackson2HttpMessageConverter jsonMessageConverter = new MappingJackson2HttpMessageConverter();
                jsonMessageConverter.setObjectMapper(ObjectMapperUtil.getObjectMapper());
                messageConverters.add(jsonMessageConverter);
                RestTemplate restTemplate = new RestTemplate();
                restTemplate.setMessageConverters(messageConverters);
                setupProxy(restTemplate);

                ParameterizedTypeReference<LeadResponse> typeReference = new ParameterizedTypeReference<LeadResponse>() {};
                ResponseEntity<LeadResponse> responseEntity = restTemplate.exchange(url, HttpMethod.POST, entity, typeReference);

                LOGGER.info("Response from LeadService {}", kv("salesForceId", responseEntity.getBody().getSalesforceId()));
            }
        }
    }

    private void setupProxy(RestTemplate restTemplate) {
        if (url.startsWith("http:") && System.getProperty(HTTP_PROXY_USER) != null) {
            CredentialsProvider credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                    new AuthScope(null, -1),
                    new UsernamePasswordCredentials(System.getProperty(HTTP_PROXY_USER), System.getProperty(HTTP_PROXY_PASSWORD)));
            HttpClient httpClient = HttpClients.custom().setDefaultCredentialsProvider(credsProvider).build();
            restTemplate.setRequestFactory(new HttpComponentsClientHttpRequestFactory(httpClient));
        }
        if (url.startsWith("https") && System.getProperty(HTTPS_PROXY_USER) != null) {
            CredentialsProvider credsProvider = new BasicCredentialsProvider();
            credsProvider.setCredentials(
                    new AuthScope(null, -1),
                    new UsernamePasswordCredentials(System.getProperty(HTTPS_PROXY_USER), System.getProperty(HTTPS_PROXY_PASSWORD)));
            HttpClient httpClient = HttpClients.custom().setDefaultCredentialsProvider(credsProvider).build();
            restTemplate.setRequestFactory(new HttpComponentsClientHttpRequestFactory(httpClient));
        }
    }

    /**
     * Updates the payload data object which contains commonly used fields
     * @param data
     */
    protected abstract LeadRequest updatePayloadData(final Data data);
}
