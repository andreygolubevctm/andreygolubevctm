package com.ctm.web.simples.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.transaction.dao.TransactionLockDao;
import com.ctm.web.simples.dao.UserDao;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class SimplesTickleServiceTest {
    private long transactionId = 1234567;
    private HttpServletRequest request;
    private UserDao userDao;
    private FatalErrorService fatalErrorService;
    private AuthenticatedData authenticatedData;
    private SimplesTickleService service;
    private TransactionLockDao transactionLockDao = mock(TransactionLockDao.class);

    @Before
    public void setup() throws SQLException, DaoException {
        SessionDataService sessionDataService = mock(SessionDataService.class);
        request = mock(HttpServletRequest.class);
        when(request.getParameter("doTickle")).thenReturn("true");
        userDao = mock(UserDao.class);
        fatalErrorService = mock(FatalErrorService.class);
        service = new SimplesTickleService(sessionDataService);
        authenticatedData = new AuthenticatedData();
    }

    @Test
    public void testShouldReturnErrorIfNoUid() throws ServletException {
        authenticatedData.put("login/user/simplesUid", null);
        boolean result = service.simplesTickle(request, transactionId, authenticatedData, userDao, fatalErrorService);
        assertFalse(result);

        authenticatedData.put("login/user/simplesUid", "test");
        result = service.simplesTickle(request, transactionId, authenticatedData, userDao, fatalErrorService);
        assertFalse(result);

        authenticatedData.put("login/user/simplesUid", "");
        result = service.simplesTickle(request, transactionId, authenticatedData, userDao, fatalErrorService);
        assertFalse(result);
    }

    @Test
    public void testShouldReturnSuccessIfUid() throws ServletException {
        authenticatedData.put("login/user/simplesUid", "100");
        boolean result = service.simplesTickle(request, transactionId, authenticatedData, userDao, fatalErrorService);
        assertTrue(result);
    }
}
