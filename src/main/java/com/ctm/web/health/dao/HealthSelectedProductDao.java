package com.ctm.web.health.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HealthSelectedProductDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthSelectedProductDao.class);


	public HealthSelectedProductDao() {}


    public HealthSelectedProductDao(final long transactionId, final long productId, final String productXML) throws DaoException {
    	addSelectedProduct(transactionId, productId, productXML);
    }

    public void addSelectedProduct(final long transactionId, final long productId, final String productXML) throws DaoException {

        final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        PreparedStatement stmt = null;

        try {
            stmt = dbSource.getConnection().prepareStatement(
            "INSERT INTO ctm.health_selected_product (transactionId, productId, productXML) VALUES (?,?,?); "
            );
            stmt.setLong(1, transactionId);
            stmt.setLong(2, productId);
            stmt.setString(3, productXML);

            stmt.executeUpdate();
        } catch (NamingException | SQLException e) {
            throw new DaoException(e);
        } finally {
            if(stmt != null) {
                try {
                    stmt.close();
                } catch (final SQLException e) {
                    LOGGER.error("Failed to close addSelectedProduct db connection {}", kv("errorMessage", e.getMessage()), e);
                }
            }
            dbSource.closeConnection();
        }
    }

    public String getSelectedProduct(final long transactionId, final long productId) throws DaoException {

        final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        PreparedStatement stmt = null;
        String productXML = null;

        try {
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT productXML " +
                            "FROM ctm.health_selected_product " +
                            "WHERE transactionId=? AND productId=? " +
                            "ORDER BY created DESC LIMIT 1"
            );
            stmt.setLong(1, transactionId);
            stmt.setLong(2, productId);
            final ResultSet results = stmt.executeQuery();
            while (results.next()) {
                productXML = results.getString("productXML");
            }
            results.close();
            stmt.close();

        } catch (NamingException | SQLException e) {
            throw new DaoException(e);
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (final SQLException e) {
                    LOGGER.error("Failed to close getSelectedProduct db connection {}", kv("errorMessage", e.getMessage()), e);
                }
            }
            dbSource.closeConnection();
        }

        return productXML;
    }

}
