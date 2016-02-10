package com.ctm.web.life.apply.controller;

import com.ctm.common.test.TestUtil;
import com.ctm.interfaces.common.types.Status;
import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.life.apply.model.request.ozicare.OzicareApplyRequest;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.life.apply.response.LifeApplyWebResponse;
import com.github.tomakehurst.wiremock.junit.WireMockRule;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.TestRestTemplate;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

/**
 * Created by lbuchanan on 5/02/2016.
 */
public class LifeApplyControllerIT {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeApplyControllerIT.class);

    private static int TOMCAT_PORT = Integer.parseInt(System.getProperty("tomcat.port.servlet.integration"));
    private static String TOMCAT_CONTEXT = System.getProperty("web.context.integration");
    private static final String TOMCAT_URL_TEMPLATE = "http://localhost:%s/%s/%s";
    private static final int FAKE_PARTNER_ENDPOINT_PORT = 61756;

    RestTemplate template = new TestRestTemplate();

    @Rule
    public WireMockRule wireMockRule = new WireMockRule(FAKE_PARTNER_ENDPOINT_PORT);

    @Before
    public void setUp() throws Exception {
        LOGGER.info("FAKE_PARTNER_ENDPOINT_PORT {}" , FAKE_PARTNER_ENDPOINT_PORT);
        XMLUnit.setIgnoreWhitespace(true);
    }

    @Test
    public void testApplyLifeBroker() throws Exception {


        String endpoint =  Endpoint.APPLY.getValue() + LifeBrokerApplyRequest.PATH;

        // Client Request
        MultiValueMap<String, String> requestBody = new LinkedMultiValueMap<>();
        // LifeBroker Server Response
        String serviceResponseBody = TestUtil.readResource(getClass(), "testResponseLifeBrokerLeadFeed.json");


        // Setup server request/response
        stubFor(post(urlEqualTo(endpoint))
                .willReturn(aResponse()
                        .withStatus(HttpStatus.OK.value())
                        .withHeader("Content-Type", "application/json")
                        .withBody(serviceResponseBody)));


        // Http Client call
        final String url = String.format(TOMCAT_URL_TEMPLATE, TOMCAT_PORT, TOMCAT_CONTEXT,"/rest/life/apply/apply.json");
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        httpHeaders.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        HttpEntity<MultiValueMap> httpRequest = new HttpEntity<>(requestBody, httpHeaders);
        ResponseEntity<LifeApplyWebResponse> responseEntity = template.exchange(url, HttpMethod.POST, httpRequest, new ParameterizedTypeReference<LifeApplyWebResponse>() {});
        LOGGER.info("Server responded [{}][{}]", responseEntity.getStatusCode(), responseEntity.getBody());

        //Asserts
        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        LOGGER.info("responseEntity {}" , responseEntity);
        LifeApplyWebResponse payload =  responseEntity.getBody();
        assertTrue(payload.getResults().isSuccess());
    }

    @Test
    public void testApplyOzicare() throws Exception {
        // Client Request
        String requestBody = TestUtil.readResource(getClass(), "testApplyOzicare.json");
        // Ozicare Server Response
        String ozicareResponseBody = TestUtil.readResource(getClass(), "testResponseOzicareLeadFeed.xml");

        String endpoint =  Endpoint.APPLY.getValue() + OzicareApplyRequest.PATH;

        // Setup server request/response
        stubFor(post(urlEqualTo(endpoint))
                .willReturn(aResponse()
                        .withStatus(HttpStatus.OK.value())
                        .withHeader("Content-Type", "application/xml")
                        .withBody(ozicareResponseBody)));

        // Http Client call
        final String url = String.format(TOMCAT_URL_TEMPLATE, TOMCAT_PORT, TOMCAT_CONTEXT,"/rest/life/apply/apply.json");
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        httpHeaders.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> httpRequest = new HttpEntity<>(requestBody, httpHeaders);
        ResponseEntity<LifeApplyResponse> responseEntity = template.exchange(url, HttpMethod.POST, httpRequest, new ParameterizedTypeReference<LifeApplyResponse>() {});
        LOGGER.info("Server responded [{}][{}]", responseEntity.getStatusCode(), responseEntity.getBody());

        //Asserts
        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        LOGGER.info("responseEntity {}" , responseEntity);
        LifeApplyResponse payload =  responseEntity.getBody();
        assertEquals(Status.REGISTERED, payload.getResponseStatus());

    }
}