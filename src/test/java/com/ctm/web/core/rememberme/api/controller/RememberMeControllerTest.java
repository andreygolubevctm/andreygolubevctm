package com.ctm.web.core.rememberme.api.controller;

import com.ctm.test.controller.BaseControllerTest;


import com.ctm.web.core.rememberme.controller.RememberMeController;
import com.ctm.web.core.rememberme.model.RememberMeCookie;
import com.ctm.web.core.rememberme.services.RememberMeService;
import com.ctm.web.core.services.ApplicationService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Matchers;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.GeneralSecurityException;
import java.util.Optional;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@RunWith(PowerMockRunner.class)
@PrepareForTest( { ApplicationService.class, RememberMeService.class})
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
public class RememberMeControllerTest extends BaseControllerTest {
    private RememberMeCookie cookie = new RememberMeCookie("1234567890", "createdTime", "v4");

    @Mock
    private RememberMeService rememberMeService;

    private RememberMeController rememberMeController;

    @Before
    public void setup() throws Exception {
        initMocks(this);
        rememberMeController = new RememberMeController(rememberMeService);
        setUp(rememberMeController);
        PowerMockito.mockStatic(RememberMeService.class);
    }

    @Test
    public void testValidateAnswerValid() throws Exception {
        Optional<String> transactionId = Optional.of("1234567890") ;
        PowerMockito.when(RememberMeService.isRememberMeEnabled( Matchers.any(HttpServletRequest.class), any(String.class))).thenReturn(true);
        PowerMockito.when(rememberMeService.getRememberMeCookie( any(HttpServletRequest.class), anyString())).thenReturn(cookie);
        PowerMockito.when(rememberMeService.getTransactionIdFromCookie( any(String.class), Matchers.any(HttpServletRequest.class))).thenReturn(transactionId);
        PowerMockito.when(rememberMeService.validateAnswerAndLoadData( any(String.class), any(String.class), Matchers.any(HttpServletRequest.class))).thenReturn(true);
        Mockito.doNothing().when(rememberMeService).updateAttemptsCounter(Matchers.any(HttpServletRequest.class), any(HttpServletResponse.class), any(String.class));
        mvc.perform(
                MockMvcRequestBuilders
                        .get("/rest/rememberme/quote/get.json?quoteType=health&userAnswer=whatever&reviewedit=y")
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
    }

    @Test
    public void testValidateAnswerNotValid() throws Exception {
        Optional<String> transactionId = Optional.of("1234567890") ;
        PowerMockito.when(RememberMeService.isRememberMeEnabled( Matchers.any(HttpServletRequest.class), any(String.class))).thenReturn(true);
        PowerMockito.when(rememberMeService.getRememberMeCookie( any(HttpServletRequest.class), anyString())).thenThrow(new GeneralSecurityException());
        mvc.perform(
                MockMvcRequestBuilders
                        .get("/rest/rememberme/quote/get.json?quoteType=health&userAnswer=whatever&reviewedit=y")
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
    }

    @Test
    public void testDeleteCookie() throws Exception {
        PowerMockito.when(rememberMeService.getRememberMeCookie( Matchers.any(HttpServletRequest.class), any(String.class))).thenReturn(cookie);
        PowerMockito.when(rememberMeService.deleteCookie( any(String.class), Matchers.any(HttpServletRequest.class), Matchers.any(HttpServletResponse.class))).thenReturn(true);
        PowerMockito.when(rememberMeService.removeAttemptsSessionAttribute( Matchers.any(HttpServletRequest.class), any(String.class))).thenReturn(true);
        mvc.perform(
                MockMvcRequestBuilders
                        .post("/rest/rememberme/quote/deleteCookie.json?quoteType=health")
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
    }

    @Test
    public void testDeleteCookieNoCookie() throws Exception {
        PowerMockito.when(rememberMeService.getRememberMeCookie( Matchers.any(HttpServletRequest.class), any(String.class))).thenReturn(null);
        mvc.perform(
                MockMvcRequestBuilders
                        .post("/rest/rememberme/quote/deleteCookie.json?quoteType=health")
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
    }
}
