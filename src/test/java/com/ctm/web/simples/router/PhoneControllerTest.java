package com.ctm.web.simples.router;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.jackson.DefaultJacksonMappers;
import com.ctm.interfaces.common.exception.InvalidQuoteException;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.InteractionService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.phone.inin.InInIcwsService;
import com.ctm.web.simples.phone.inin.model.RecordSnippetResponse;
import com.ctm.web.simples.phone.inin.model.ConnectionReq;
import com.ctm.web.simples.phone.inin.model.ConnectionResp;
import com.ctm.web.simples.phone.inin.model.PauseResumeResponse;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.servlet.ServletException;

import static org.junit.Assert.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {DefaultJacksonMappers.class, Jackson2ObjectMapperBuilder.class})
public class PhoneControllerTest {
    @Autowired
    private SerializationMappers jacksonMappers;


    @InjectMocks
    InInIcwsService inInIcwsService;

    @Test
    public void testHandleException() throws Exception {
        PhoneController phoneController = new PhoneController(mock(SessionDataServiceBean.class), mock(InInIcwsService.class), mock(IPAddressHandler.class), mock(InteractionService.class));
        InvalidQuoteException exceptionMock = mock(InvalidQuoteException.class);
        when(exceptionMock.getMessage()).thenReturn("Failed!");

        ErrorInfo info = phoneController.handleException(exceptionMock);
        Assert.assertEquals("Failed!", info.getErrors().get("message"));

        // {"trackingKey":null,"transactionId":null,"errors":{"message":"Failed"}}
        String actual = jacksonMappers.getJsonMapper().writeValueAsString(info);
        assertTrue(actual.contains("\"errors\":{\"message\":\"Failed!\"}"));

        // {"success":false,"errors":[{"message":"PauseResume fail"}]}
        actual = jacksonMappers.getJsonMapper().writeValueAsString(PauseResumeResponse.fail("PauseResume fail"));
        assertTrue(actual.contains("\"errors\":{\"message\":\"PauseResume fail\"}"));
    }

    @Test
    public void testVoiceSnipingWhenParameterMissing() throws ConfigSettingException, DaoException, ServletException {
        PhoneController phoneController = new PhoneController(mock(SessionDataServiceBean.class), mock(InInIcwsService.class), mock(IPAddressHandler.class), mock(InteractionService.class));

        Client<ConnectionReq, ConnectionResp> connectionClientMock = mock(Client.class);

        inInIcwsService = new InInIcwsService(mock(InteractionService.class),mock(SerializationMappers.class), mock(InInConfig.class).setCicPrimaryUrl("${cicUrl}/${sessionId}/interactions/103456789/record-snippet"),
                connectionClientMock, mock(Client.class), mock(Client.class), mock(Client.class), mock(Client.class), mock(Client.class));

        MockHttpServletRequest mockHttpServletRequest = new MockHttpServletRequest("POST", "${cicUrl}/${sessionId}/interactions/103456789/record-snippet");
        mockHttpServletRequest.setParameter("snippingOn1", "true");
        mockHttpServletRequest.setParameter("supervisor", "false");
        mockHttpServletRequest.setParameter("operatorId", "user");

        MockHttpServletResponse mockHttpServletResponse = new MockHttpServletResponse();

        RecordSnippetResponse response = phoneController.apiVoiceSnipping(mockHttpServletRequest, mockHttpServletResponse);

        assertEquals(response.getError().getMessage(), "GET request missing snippingOn param");
        assertEquals(response.isSuccess(), false);
        assertNull(response.getInteractionId());
    }
}