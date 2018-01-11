package com.ctm.web.core.rememberme.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.web.go.Data;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.GeneralSecurityException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Mockito.only;
import static org.mockito.Mockito.verify;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PowerMockIgnore({"javax.crypto.*"})
@PrepareForTest({SettingsService.class})
public class RememberMeServiceTest {
    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private SessionDataServiceBean sessionDataServiceBean;

    @Mock
    private TransactionDetailsDao transactionDetailsDao;

    @Mock
    private TransactionDao transactionDao;

    @Mock
    private javax.servlet.http.HttpSession session;

    private RememberMeService service;

    @Mock
    private PageSettings pageSettings;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        PowerMockito.mockStatic(ApplicationService.class);
        PowerMockito.mockStatic(SettingsService.class);
        service = new RememberMeService(sessionDataServiceBean, transactionDetailsDao, transactionDao);

    }

    @Test
    public void testDeleteCookie() throws GeneralSecurityException {
        final ArgumentCaptor<Cookie> cookieCaptor = ArgumentCaptor.forClass(Cookie.class);
        service.deleteCookie("health", response);
        verify(response, only()).addCookie(cookieCaptor.capture());
        final Cookie cookie = cookieCaptor.getValue();
        assertEquals("/", cookie.getPath());
        assertEquals("", cookie.getValue());
        assertEquals(0, cookie.getMaxAge());
    }

    @Test
    public void testRememberMeCookieNotPresent() throws DaoException, ConfigSettingException, GeneralSecurityException {
        final String verticalCode = "health";
        when(request.getCookies()).thenReturn(new Cookie[]{new Cookie("a", "a"), new Cookie("b", "b")});
        PowerMockito.when(SettingsService.getPageSettingsForPage(request, verticalCode)).thenReturn(pageSettings);
        when(pageSettings.getSettingAsBoolean("rememberMeEnabled")).thenReturn(true);
         assertFalse(service.hasRememberMe(request, "health"));
    }

    @Test
    public void testRememberMeCookieExists() throws GeneralSecurityException, DaoException, ConfigSettingException {
        final String verticalCode = "health";
        final String cookieName = getCookieName();
        when(request.getCookies()).thenReturn(new Cookie[]{new Cookie("a", "a"), new Cookie(cookieName, "b"), new Cookie("c", "c")});
        PowerMockito.when(SettingsService.getPageSettingsForPage(request, verticalCode)).thenReturn(pageSettings);
        when(pageSettings.getSettingAsBoolean("rememberMeEnabled")).thenReturn(true);
        assertTrue(service.hasRememberMe(request, "health"));
    }

    @Test
    public void testSetCookieLocalhost() throws Exception {
        final ArgumentCaptor<Cookie> argumentCaptor = ArgumentCaptor.forClass(Cookie.class);
        EnvironmentService.setEnvironment(EnvironmentService.Environment.LOCALHOST.name());
        service.setCookie("health", 12345678L, response);
        verify(response, only()).addCookie(argumentCaptor.capture());
        final Cookie cookie = argumentCaptor.getValue();
        assertEquals("/", cookie.getPath());
        assertEquals(2592000, cookie.getMaxAge()); // 30 days
    }

    @Test
    public void testSetCookiePRO() throws Exception {
        final ArgumentCaptor<Cookie> argumentCaptor = ArgumentCaptor.forClass(Cookie.class);
        EnvironmentService.setEnvironment(EnvironmentService.Environment.PRO.name());

        service.setCookie("health", 12345678L, response);

        verify(response, only()).addCookie(argumentCaptor.capture());

        final Cookie cookie = argumentCaptor.getValue();
        assertEquals("/", cookie.getPath());
        assertEquals(2592000, cookie.getMaxAge()); // 30populateDataBucket days
        assertTrue(cookie.getSecure());
        assertEquals("secure.comparethemarket.com.au", cookie.getDomain());
    }

    @Test
    public void testSetCookieReset() throws Exception {
        final ArgumentCaptor<Cookie> argumentCaptor = ArgumentCaptor.forClass(Cookie.class);
        EnvironmentService.setEnvironment(EnvironmentService.Environment.LOCALHOST.name());

        final Cookie existingCookie = new Cookie(getCookieName(), "99999999");
        existingCookie.setMaxAge(600);

        when(request.getCookies()).thenReturn(new Cookie[]{existingCookie});
        service.setCookie("health", 12345678L, response);

        verify(response, only()).addCookie(argumentCaptor.capture());

        final Cookie cookie = argumentCaptor.getValue();
        assertEquals(2592000, cookie.getMaxAge()); // 30 days
        String decryptValue = StringEncryption.decrypt(RememberMeService.getSecretKey(), cookie.getValue());
        assertEquals("12345678", decryptValue.substring(0,decryptValue.indexOf(":")));
    }

    @Test
    public void testValidateAnswer() throws GeneralSecurityException, DaoException, SessionException {
        final Long cookieTransactionId = 12345678L;
        final Data data = new Data();
        final String validAnswer = "01/02/1985";
        final String invalidAnswer = "01/02/1983";
        when(request.getSession()).thenReturn(session);
        when(request.getSession().getAttribute("sessionData")).thenReturn(new SessionData());
        when(request.getCookies()).thenReturn(new Cookie[]{new Cookie(getCookieName(), getTransactionId())});
        when(sessionDataServiceBean.getDataForTransactionId(request, "12345678", true)).thenReturn(data);
        when(transactionDetailsDao.getTransactionDetails(cookieTransactionId)).thenReturn(createTransactionDetails());
        assertTrue(service.validateAnswerAndLoadData(Vertical.VerticalType.HEALTH.name().toLowerCase(), validAnswer, request));
        assertEquals("<this><health><situation><healthCvr>F</healthCvr><location>Brisbane</location></situation><contactDetails>" +
                        "<name>aName</name></contactDetails><healthCover><primary><dob>01/02/1985</dob></primary></healthCover></health>" +
                        "<current><verticalCode>HEALTH</verticalCode><brandCode>ctm</brandCode><transactionId>12345678</transactionId></current><rootId>12345678</rootId></this>",
                data.toString());
        assertFalse(service.validateAnswerAndLoadData(Vertical.VerticalType.HEALTH.name().toLowerCase(), invalidAnswer, request));
    }

    private List<TransactionDetail> createTransactionDetails() {
        final List<TransactionDetail> list = new ArrayList<>();
        list.add(new TransactionDetail("health/situation/healthCvr", "F"));
        list.add(new TransactionDetail("health/situation/location", "Brisbane"));
        list.add(new TransactionDetail("health/contactDetails/name", "aName"));
        list.add(new TransactionDetail("health/healthCover/primary/dob", "01/02/1985"));
        return list;
    }

    private String getCookieName() throws GeneralSecurityException {
        return StringEncryption.encrypt(RememberMeService.getSecretKey(), "health" + "RememberMe");
    }

    private String getTransactionId() throws GeneralSecurityException {
       // return StringEncryption.encrypt(RememberMeService.getSecretKey(), "12345678");
        return StringEncryption.encrypt(RememberMeService.getSecretKey(), "12345678"+":"+ LocalDateTime.now().toString());
    }
}