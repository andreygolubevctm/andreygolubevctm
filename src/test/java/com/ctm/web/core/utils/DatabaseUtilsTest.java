package com.ctm.web.core.utils;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.junit.Before;
import org.junit.Test;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.SQLException;
import org.slf4j.Logger;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;

public class DatabaseUtilsTest {
    private SimpleDatabaseConnection dbSource = mock(SimpleDatabaseConnection.class);
    private Connection connection = mock(Connection.class);
    private Logger logger = mock(Logger.class);


    @Before
    public void setup() throws SQLException, NamingException {
        when(dbSource.getConnection()).thenReturn(connection);
        when(dbSource.getConnection(any(String.class), any(Boolean.class))).thenReturn(connection);
    }

    @Test
    public void testResetDefaultsAndCloseConnection() throws SQLException, DaoException {
        doNothing().when(connection).commit();
        doNothing().when(connection).setAutoCommit(anyBoolean());
        doNothing().when(dbSource).closeConnection();
        DatabaseUtils.resetDefaultsAndCloseConnection(dbSource, true);
    }

    @Test(expected = DaoException.class)
    public void testResetDefaultsAndCloseConnectionWithException() throws SQLException, DaoException {
        doNothing().when(connection).commit();
        doThrow(new SQLException()).when(connection).setAutoCommit(anyBoolean());
        doNothing().when(dbSource).closeConnection();
        DatabaseUtils.resetDefaultsAndCloseConnection(dbSource, true);
    }

    @Test
    public void testRollbackTransaction() throws SQLException, DaoException {
        doNothing().when(connection).rollback();
        doNothing().when(logger).error(anyString());
        DatabaseUtils.rollbackTransaction(dbSource, logger);
    }

    @Test(expected = DaoException.class)
    public void testRollbackTransactionWithException() throws SQLException, DaoException {
        doNothing().when(logger).error(anyString());
        doThrow(new SQLException()).when(connection).rollback();
        DatabaseUtils.rollbackTransaction(dbSource, logger);
    }
}
