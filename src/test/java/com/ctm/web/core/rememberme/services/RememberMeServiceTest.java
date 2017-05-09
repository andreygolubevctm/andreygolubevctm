package com.ctm.web.core.rememberme.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.web.go.Data;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;

@RunWith(MockitoJUnitRunner.class)
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

    private RememberMeService service;

    @Before
    public void setUp() {
        initMocks(this);

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
    public void testHasRememberMeFalse() {
        when(request.getCookies()).thenReturn(new Cookie[] {new Cookie("a" , "a"), new Cookie("b", "b")});
        assertFalse(service.hasRememberMe(request, "health"));
    }

    @Test
    public void testHasRememberMeTrue() throws GeneralSecurityException {
        final String cookieName = getCookieName();
        when(request.getCookies()).thenReturn(new Cookie[] {new Cookie("a" , "a"), new Cookie(cookieName, "b"), new Cookie("c", "c")});
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
        assertEquals(getTransactionId(), cookie.getValue());
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
        assertEquals(getTransactionId(), cookie.getValue());
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

        when(request.getCookies()).thenReturn(new Cookie[] {existingCookie});
        service.setCookie("health", 12345678L, response);

        verify(response, only()).addCookie(argumentCaptor.capture());

        final Cookie cookie = argumentCaptor.getValue();
        assertEquals(2592000, cookie.getMaxAge()); // 30 days
        assertEquals("12345678", StringEncryption.decrypt(RememberMeService.getSecretKey(), cookie.getValue()));
    }

    @Test
    public void testValidateAnswer() throws GeneralSecurityException, DaoException, SessionException {
        final Long cookieTransactionId = 12345678L;
        final Long rootId = 11111111L;
        final Long lastTransactionId = 22222222L;
        final Data data = new Data();
        final String answer="01/02/1985";

        when(request.getCookies()).thenReturn(new Cookie[]{new Cookie(getCookieName(), getTransactionId())});
        when(sessionDataServiceBean.getDataForTransactionId(request, "12345678", true)).thenReturn(data);
        when(transactionDao.getRootIdOfTransactionId(cookieTransactionId)).thenReturn(rootId);
        when(transactionDao.getLatestTransactionIdByRootId(rootId)).thenReturn(lastTransactionId);
        when(transactionDetailsDao.getTransactionDetails(lastTransactionId)).thenReturn(createTransactionDetails());


        service.validateAnswerAndLoadData(Vertical.VerticalType.HEALTH.name().toLowerCase(), answer, request);

        assertEquals("<this><health><situation><healthCvr>F</healthCvr><location>Brisbane</location></situation><healthCover><primary><dob>01/02/1985</dob></primary></healthCover></health></this>",
                data.toString());
    }

    private List<TransactionDetail> createTransactionDetails() {
        final List<TransactionDetail> list = new ArrayList<>();
        list.add(new TransactionDetail("health/situation/healthCvr", "F"));
        list.add(new TransactionDetail("health/situation/location", "Brisbane"));
        list.add(new TransactionDetail("health/contactDetails/name", "aName"));
        list.add(new TransactionDetail("invalid/xpath", "aaaa"));
        list.add(new TransactionDetail( "health/healthCover/primary/dob", "01/02/1985"));

        return list;
    }

    private String getCookieName() throws GeneralSecurityException {
        return StringEncryption.encrypt(RememberMeService.getSecretKey(), "healthRememberMe");
    }

    private String getTransactionId() throws GeneralSecurityException {
        return StringEncryption.encrypt(RememberMeService.getSecretKey(), "12345678");
    }
}