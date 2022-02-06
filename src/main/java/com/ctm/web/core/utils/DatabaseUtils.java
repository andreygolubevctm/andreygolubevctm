package com.ctm.web.core.utils;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.slf4j.Logger;

import javax.naming.NamingException;
import java.sql.SQLException;

public class DatabaseUtils {

    /**
     * This method will roleback the changes made via connection in supplied SimpleDatabaseConnection
     * @param dbSource
     * @throws DaoException
     */
    public static void rollbackTransaction(SimpleDatabaseConnection dbSource, Logger LOGGER) throws DaoException {
        try {
            LOGGER.error("Transaction is being rolled back");
            dbSource.getConnection().rollback();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
    }

    /**
     * This method will reset autocommit option to the default value and also commit changes and close the connection
     * @param dbSource
     * @throws DaoException
     */
    public static void resetDefaultsAndCloseConnection(SimpleDatabaseConnection dbSource, boolean autoCommitFlag) throws DaoException {
        try {
            dbSource.getConnection().commit();
            dbSource.getConnection().setAutoCommit(autoCommitFlag);
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        dbSource.closeConnection();
    }
}
