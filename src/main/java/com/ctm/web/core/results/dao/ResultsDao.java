package com.ctm.web.core.results.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.results.model.ResultProperty;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class ResultsDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(ResultsDao.class);

	/**
	 * Returns an array of product properties stored against a transaction id with specific productId.
	 * These are specific xpaths from the results set that were stored after the results were returned.
	 *
	 * @param transactionId
	 * @param productId (optional)
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<ResultProperty> getResultPropertiesForTransaction(Long transactionId, String productId) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<ResultProperty> properties = new ArrayList<ResultProperty>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			if(productId != null && !productId.isEmpty()) {
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT transactionId, productId, property, value " +
					"FROM aggregator.results_properties rp " +
					"WHERE rp.transactionId = ? AND rp.productId = ?; "
				);

				stmt.setString(2, productId);
			} else {
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT transactionId, productId, property, value " +
					"FROM aggregator.results_properties rp " +
					"WHERE rp.transactionId = ? ; "
				);
			}

			stmt.setLong(1, transactionId);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {

				ResultProperty property = new ResultProperty();
				property.setTransactionId(result.getLong("transactionId"));
				property.setProductId(result.getString("productId"));
				property.setProperty(result.getString("property"));
				property.setValue(result.getString("value"));
				properties.add(property);

			}

		} catch (Exception e) {
			LOGGER.error("Failed to get result properties for transaction {}, {}", kv("transactionId", transactionId), kv("productId", productId));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return properties;
	}

	/**
	 * Returns an integer for the age of results against a transaction id.
	 *
	 * Returns -1 if no results exist.
	 *
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 */
	public int getAgeOfResultsForTransaction(Long transactionId) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		int age = -1;

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT ABS(DATEDIFF(( " +
				"	SELECT MAX(d.dateValue) FROM aggregator.transaction_details AS d " +
				"	RIGHT JOIN ctm.touches AS t ON t.transaction_id = d.transactionId AND t.type = 'R' " +
				"	WHERE transactionId = ? " +
				"),NOW())) AS age;"
			);

			stmt.setLong(1, transactionId);

			ResultSet result = stmt.executeQuery();

			if(result.first()){
				age = result.getInt("age");
			}

		} catch (Exception e) {
			LOGGER.error("Failed to get age of results for transaction {}", kv("transactionId", transactionId));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return age;
	}


	/**
	 * Returns a single property value stored against a transaction id with specific productId and request property.
	 * These are specific xpaths from the results set that were stored after the results were returned.
	 *
	 * @param transactionId
	 * @param productId
	 * @param property
	 * @return
	 * @throws DaoException
	 */
	public String getSingleResultPropertyValue(Long transactionId, String productId, String property) {

		SimpleDatabaseConnection dbSource = null;

		String propertyValue = "";

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT value " +
				"FROM aggregator.results_properties rp " +
				"WHERE rp.transactionId = ? AND rp.productId = ? AND rp.property = ?; "
			);

			stmt.setLong(1, transactionId);
			stmt.setString(2, productId);
			stmt.setString(3, property);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				propertyValue = result.getString("value");
			}

		} catch (Exception e) {
			LOGGER.error("Failed to get single result property value {}, {}, {}", kv("transactionId", transactionId),
				kv("productId", productId), kv("property", property));
		} finally {
			dbSource.closeConnection();
		}

		return propertyValue;
	}

    public void saveResultsProperties(List<ResultProperty> resultProperties) throws Exception {

        try (SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection()) {

			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"INSERT INTO aggregator.results_properties (transactionId,productId,property,value) " +
							"VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE `value`='DUPLICATE'"
			);

			for (ResultProperty resultProperty : resultProperties) {
				stmt.setLong(1, resultProperty.getTransactionId());
				stmt.setString(2, resultProperty.getProductId());
				stmt.setString(3, resultProperty.getProperty());
				stmt.setString(4, resultProperty.getValue());
				stmt.addBatch();
			}

			stmt.executeBatch();

		}
    }
}
