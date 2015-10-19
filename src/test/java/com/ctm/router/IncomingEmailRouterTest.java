package com.ctm.router;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.model.email.IncomingEmail;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.AccessTouchService;
import com.ctm.services.SettingsService;
import com.ctm.services.email.IncomingEmailService;
import com.ctm.services.email.token.EmailTokenService;
import com.ctm.services.email.token.EmailTokenServiceFactory;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import static org.mockito.Mockito.*;

import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import static org.powermock.api.mockito.PowerMockito.*;
import static org.mockito.Matchers.*;
import static org.powermock.api.mockito.PowerMockito.when;

import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
    }

    @Test
    public void testGatewayWithHashedEmailWithoutEmailUrl() throws IOException, ServletException {
        when(request.getParameter("id")).thenReturn("12345678");
        when(incomingEmailService.getRedirectionUrl(notNull(IncomingEmail.class))).thenReturn("www.awesomeness.com.au");

        Mockito.doNothing().when(accessTouchService).setRequest(request);
        Mockito.when(accessTouchService.recordTouchWithProductCode(anyLong(), anyString(), anyString())).thenReturn(true);

        router.doGet(request, response);

        verify(accessTouchService).recordTouchWithProductCode(12345678L, "EmlGateway", "");
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
        Mockito.when(accessTouchService.recordTouchWithProductCode(anyLong(), anyString(), anyString())).thenReturn(true);

        router.doGet(request, response);

        verify(accessTouchService).recordTouchWithProductCode(12345678L, "EmlGateway", "");
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
        verify(emailTokenService).decryptToken("myToken");
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
        verify(emailTokenService).decryptToken("myToken");
        verify(response).sendRedirect("www.awesomeness.com.au/start_quote.jsp");
    }
}
