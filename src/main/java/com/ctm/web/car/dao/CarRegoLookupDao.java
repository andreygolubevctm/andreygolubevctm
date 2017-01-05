package com.ctm.web.car.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.springframework.stereotype.Component;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class CarRegoLookupDao {
    private static final String LOG_TABLE = "ctm.rego_lookup_usage";

    public CarRegoLookupDao(){}

    /**
     * getTodaysUsage - returns the number of requests for today
     * @return
     * @throws DaoException
     */
    public int getTodaysUsage() throws DaoException {
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
    public static void logLookup(Long transactionId, String plateNumber, String state, String status, String motorwebNvic, String motorwebRedbook) throws DaoException {
        SimpleDatabaseConnection dbSource = null;
        try {
            dbSource = new SimpleDatabaseConnection();

            String resultCount = null;
            if (motorwebNvic != null) {
                PreparedStatement count = dbSource.getConnection().prepareStatement(
                        "SELECT COUNT(*) FROM aggregator.glasses_extract ge WHERE ge.nvicde = ? AND ge.redbookCode IS NOT NULL AND ge.redbookCode != ''");
                count.setString(1, motorwebNvic);
                ResultSet rs = count.executeQuery();
                while (rs.next()) {
                    resultCount = rs.getString(1);
                }
            }

            PreparedStatement stmt;
            stmt = dbSource.getConnection().prepareStatement(
                    "INSERT INTO " + LOG_TABLE + " " +
                    "(regoLookupPlate,regoLookupState,regoLookupTransactionId,regoLookupStatus,motorweb_nvic,motorweb_redbook,motorweb_nvic_ctm_matches) " +
                    "VALUES(?,?,?,?,?,?,?)"
            );

            stmt.setString(1, plateNumber);
            stmt.setString(2, state);
            stmt.setLong(3, transactionId);
            stmt.setString(4, status);
            stmt.setString(5, motorwebNvic);
            stmt.setString(6, motorwebRedbook);
            stmt.setString(7, resultCount);

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
