package com.ctm.web.car.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CarRegoLookupDao {
    private static final String LOG_TABLE = "ctm.rego_lookup_usage";

    public CarRegoLookupDao(){}

    /**
     * getTodaysUsage - returns the number of requests for today
     * @return
     * @throws DaoException
     */
    public static int getTodaysUsage() throws DaoException {
        int usage = 0;
        SimpleDatabaseConnection dbSource = null;

        try {
            PreparedStatement stmt;
            dbSource = new SimpleDatabaseConnection();

            stmt = dbSource.getConnection().prepareStatement(
                "SELECT COUNT(regoLookupId) AS dailyCount FROM " + LOG_TABLE + " " +
                "WHERE Date(regoLookupDatetime) = CURRENT_DATE"
            );

            ResultSet results = stmt.executeQuery();

            if (results.next()) {
                usage = results.getInt("dailyCount");
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        finally {
            dbSource.closeConnection();
        }

        return usage;
    }

    /**
     * logLookup - stores core data for each rego lookup attempted
     *
     * @param transactionId
     * @param plateNumber
     * @param state
     * @param status
     * @throws DaoException
     */
    public static void logLookup(Long transactionId, String plateNumber, String state, String status) throws DaoException {

        SimpleDatabaseConnection dbSource = null;

        try {
            PreparedStatement stmt;
            dbSource = new SimpleDatabaseConnection();

            stmt = dbSource.getConnection().prepareStatement(
                    "INSERT INTO " + LOG_TABLE + " " +
                    "(regoLookupPlate,regoLookupState,regoLookupTransactionId,regoLookupStatus) " +
                    "VALUES(?,?,?,?)"
            );

            stmt.setString(1, plateNumber);
            stmt.setString(2, state);
            stmt.setLong(3, transactionId);
            stmt.setString(4, status);

            stmt.executeUpdate();
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        finally {
            dbSource.closeConnection();
        }
    }
}
