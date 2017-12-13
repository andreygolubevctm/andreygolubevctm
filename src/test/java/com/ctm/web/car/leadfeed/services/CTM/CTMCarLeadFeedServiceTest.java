package com.ctm.web.car.leadfeed.services.CTM;

import com.ctm.web.core.leadfeed.model.CTMCarBestPriceLeadFeedRequest;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import static org.junit.Assert.*;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class CTMCarLeadFeedServiceTest {

    CTMCarLeadFeedService ctmCarLeadFeedService;
    @Mock
    private RestTemplate restTemplate;

    @Before
    public void setup(){
        initMocks(this);
        ctmCarLeadFeedService = new CTMCarLeadFeedService("http://test", restTemplate);
    }

    @Test
    public void process() throws Exception {

    }

    @Test
    public void givenValidRequestAnd200OkResponseFromCtmLeads_whenSendLeadFeedRequestToCtmLeads_thenReturnSuccessResponse() throws Exception {
        //given
        CTMCarBestPriceLeadFeedRequest request = new CTMCarBestPriceLeadFeedRequest();

        final Object response = new ObjectMapper().readValue("{\"outcome\": \"SUCCESS\"}", Object.class);

        ResponseEntity<Object> responseEntity = new ResponseEntity<Object>(response, HttpStatus.OK);
        ArgumentCaptor<HttpEntity> argumentCaptor = ArgumentCaptor.forClass(HttpEntity.class);
        when(restTemplate.postForEntity(anyObject(), argumentCaptor.capture(), any())).thenReturn(responseEntity);

        //when
        final LeadFeedService.LeadResponseStatus leadResponseStatus = this.ctmCarLeadFeedService.sendLeadFeedRequestToCtmLeads(request);

        //then
        assertEquals(LeadFeedService.LeadResponseStatus.SUCCESS, leadResponseStatus);
    }

    @Test
    public void givenValidRequestAnd500ErrorResponseFromCtmLeads_whenSendLeadFeedRequestToCtmLeads_thenReturnFailureResponse() throws Exception {
        //given
        CTMCarBestPriceLeadFeedRequest request = new CTMCarBestPriceLeadFeedRequest();

        ArgumentCaptor<HttpEntity> argumentCaptor = ArgumentCaptor.forClass(HttpEntity.class);
        when(restTemplate.postForEntity(anyObject(), argumentCaptor.capture(), any())).thenThrow(new HttpClientErrorException(HttpStatus.INTERNAL_SERVER_ERROR));

        //when
        final LeadFeedService.LeadResponseStatus leadResponseStatus = this.ctmCarLeadFeedService.sendLeadFeedRequestToCtmLeads(request);

        //then
        assertEquals(LeadFeedService.LeadResponseStatus.FAILURE, leadResponseStatus);
    }
}