package com.ctm.web.core.router;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.email.services.IncomingEmailService;
import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.email.services.token.EmailTokenServiceFactory;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.email.integration.emailservice.EmailServiceClient;
import com.ctm.web.email.integration.emailservice.TokenResponse;
import org.apache.catalina.core.ApplicationContext;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.mockito.Mockito.*;
import static org.powermock.api.mockito.PowerMockito.*;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.springframework.test.util.ReflectionTestUtils.setField;

/**
 * Created by voba on 19/10/2015.
 */
@RunWith(PowerMockRunner.class)
@PrepareForTest({IncomingEmailRouter.class, IncomingEmailService.class, AccessTouchService.class, EmailTokenServiceFactory.class, SettingsService.class})
public class IncomingEmailRouterTest {
    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private AccessTouchService accessTouchService;

    @Mock
    private IncomingEmailService incomingEmailService;

    @Mock
    private EmailTokenService emailTokenService;

    @Mock
    private PageSettings pageSettings;

    @Mock
    private WebApplicationContext applicationContext;

    @Mock
    private EmailServiceClient emailServiceClient;

    @Mock
    private EmailMasterDao emailMasterDao;

    private IncomingEmailRouter router;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.initMocks(this);
        router = new IncomingEmailRouter();

        whenNew(IncomingEmailService.class).withNoArguments().thenReturn(incomingEmailService);
        whenNew(AccessTouchService.class).withNoArguments().thenReturn(accessTouchService);

        mockStatic(EmailTokenServiceFactory.class);
        when(EmailTokenServiceFactory.getEmailTokenServiceInstance(any())).thenReturn(emailTokenService);

        mockStatic(SettingsService.class);
        when(SettingsService.getPageSettings(anyInt(), anyString())).thenReturn(pageSettings);

        setField(router, "emailServiceClient", emailServiceClient);
    }

    @Test
    public void testGatewayWithHashedEmailWithoutEmailUrl() throws IOException, ServletException {
        when(request.getParameter("id")).thenReturn("12345678");
        when(incomingEmailService.getRedirectionUrl(notNull(IncomingEmail.class))).thenReturn("www.awesomeness.com.au");

        Mockito.doNothing().when(accessTouchService).setRequest(request);
        Mockito.when(accessTouchService.recordTouchWithProductCodeDeprecated(anyLong(), anyString(), anyString())).thenReturn(true);

        router.doGet(request, response);

        verify(accessTouchService).recordTouchWithProductCodeDeprecated(12345678L, "EmlGateway", "");
        verify(response).sendRedirect("www.awesomeness.com.au");
    }

    @Test
    public void testGatewayWithToken() throws IOException, ServletException {
        when(request.getParameter("token")).thenReturn("myToken");

        IncomingEmail incomingEmail = new IncomingEmail();
        incomingEmail.setTransactionId(12345678L);
        when(emailTokenService.getIncomingEmailDetails(anyString())).thenReturn(incomingEmail);
        when(incomingEmailService.getRedirectionUrl(notNull(IncomingEmail.class))).thenReturn("www.awesomeness.com.au");

        Mockito.doNothing().when(accessTouchService).setRequest(request);
        Mockito.when(accessTouchService.recordTouchWithProductCodeDeprecated(anyLong(), anyString(), anyString())).thenReturn(true);

        router.doGet(request, response);

        verify(accessTouchService).recordTouchWithProductCodeDeprecated(12345678L, "EmlGateway", "");
        verify(response).sendRedirect("www.awesomeness.com.au");
    }

    @Test
    public void testGatewayWithTokenNoEmailDataAndHasLogin() throws IOException, ServletException, ConfigSettingException {
        when(request.getParameter("token")).thenReturn("myToken");
        when(emailTokenService.getIncomingEmailDetails(anyString())).thenReturn(null);

        Map<String, String> params = new HashMap<>();
        params.put("styleCodeId", "1");
        when(emailTokenService.decryptToken("myToken")).thenReturn(params);
        when(pageSettings.getBaseUrl()).thenReturn("www.awesomeness.com.au/");
        when(emailTokenService.hasLogin(anyString())).thenReturn(true);

        router.doGet(request, response);

        verify(emailTokenService).getIncomingEmailDetails(anyString());
        verify(emailTokenService, atLeastOnce()).decryptToken("myToken");
        verify(response).sendRedirect("www.awesomeness.com.au/retrieve_quotes.jsp");
    }

    @Test
    public void testGatewayWithTokenNoEmailDataAndHasNoLogin() throws IOException, ServletException, ConfigSettingException {
        when(request.getParameter("token")).thenReturn("myToken");
        when(emailTokenService.getIncomingEmailDetails(anyString())).thenReturn(null);

        Map<String, String> params = new HashMap<>();
        params.put("styleCodeId", "1");
        when(emailTokenService.decryptToken("myToken")).thenReturn(params);
        when(pageSettings.getBaseUrl()).thenReturn("www.awesomeness.com.au/");
        when(emailTokenService.hasLogin(anyString())).thenReturn(false);

        router.doGet(request, response);

        verify(emailTokenService).getIncomingEmailDetails(anyString());
        verify(emailTokenService, atLeastOnce()).decryptToken("myToken");
        verify(response).sendRedirect("www.awesomeness.com.au/start_quote.jsp");
    }

    @Test
    public void givenHncToken_whenLoadingTransaction_thenRedirectToEvtJourney() throws Exception {

        // inject mock
        when(applicationContext.getBean(EmailServiceClient.class)).thenReturn(emailServiceClient);
        whenNew(EmailMasterDao.class).withAnyArguments().thenReturn(emailMasterDao);

        // a random token
        final String aHncToken = "aHncToken";
        when(request.getParameter("token")).thenReturn(aHncToken);

        // params decrypted from token
        Map<String, String> params = new HashMap<>();
        params.put("styleCodeId", "1");
        params.put("vertical", "home");
        params.put("action", "load");
        params.put("emailId", "0");
        params.put("transactionId", "0");
        when(emailTokenService.decryptToken(aHncToken)).thenReturn(params);

        // mock response of emailMasterDao.getEmailMasterById
        final EmailMaster emailMaster = new EmailMaster();
        emailMaster.setEmailAddress("my-test@test.com");
        when(emailMasterDao.getEmailMasterById(anyInt())).thenReturn(emailMaster);

        // mock response of emailServiceClient.createEmailToken
        final TokenResponse tokenResponse = TokenResponse.newBuilder().url("www.test.com").build();
        when(emailServiceClient.createEmailToken(anyInt(), any(), anyLong(), any(), any())).thenReturn(Optional.of(tokenResponse));

        router.doGet(request, response);

        // verifications
        verify(emailTokenService, atLeastOnce()).decryptToken(aHncToken);
        verify(response).sendRedirect(tokenResponse.getUrl());
    }
}
