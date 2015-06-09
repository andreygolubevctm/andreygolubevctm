package com.ctm.dao.car;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.naming.NamingException;
import org.apache.log4j.Logger;
import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

public class CarRegoLookupDao {
    @SuppressWarnings("unused")
    private static Logger logger = Logger.getLogger(CarRegoLookupDao.class.getName());

    public CarRegoLookupDao(){}

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
                    "INSERT INTO ctm.rego_lookup_usage " +
                    "(regoLookup_rego,regoLookup_state,regoLookup_transactionId,regoLookup_status) " +
                    "VALUES(?,?,?,?)"
            );

            stmt.setString(1, plateNumber);
            stmt.setString(2, state);
            stmt.setLong(3, transactionId);
            stmt.setString(4, status);

            stmt.executeUpdate();
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }
        finally {
            dbSource.closeConnection();
        }
    }
}
