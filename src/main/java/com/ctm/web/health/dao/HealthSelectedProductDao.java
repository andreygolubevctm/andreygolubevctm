package com.ctm.web.health.dao;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * Class provides methods to store and retrieve selected product data from the database.
 *
 * Simply appending records to the table is intentional as it is significantly more efficient
 * than updating records given the large size of the product XML being written. The data only
 * needs to be held temporarily so an external task will truncate the rows so that only records
 * from the last 24hrs are retained.
 */
@Service
public class HealthSelectedProductDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthSelectedProductDao.class);

	public HealthSelectedProductDao() {}

    public void addSelectedProduct(final long transactionId, final String productId, final String productXML) throws DaoException {

        final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        PreparedStatement stmt = null;

        try {
            stmt = dbSource.getConnection().prepareStatement(
            "INSERT INTO ctm.health_selected_product_apply (transactionId, productId, productXML) VALUES (?,?,?); "
            );
            stmt.setLong(1, transactionId);
            stmt.setString(2, productId);
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

    public String getSelectedProduct(final long transactionId, final String productId) throws DaoException {

        final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        PreparedStatement stmt = null;
        String productXML = null;

        try {
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT productXML " +
                            "FROM ctm.health_selected_product_apply " +
                            "WHERE transactionId=? AND productId=? " +
                            "ORDER BY created DESC LIMIT 1;"
            );
            stmt.setLong(1, transactionId);
            stmt.setString(2, productId);
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
