package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.results.ResultProperty;

public class ResultsDao {

	/**
	 * Returns an array of product properties stored against a transaction id.
	 * These are specific xpaths from the results set that were stored after the results were returned.
	 *
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<ResultProperty> getResultPropertiesForTransaction(Long transactionId) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<ResultProperty> properties = new ArrayList<ResultProperty>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT transactionId, productId, property, value " +
				"FROM aggregator.results_properties rp " +
				"WHERE rp.transactionId = ? ; "
			);

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

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return properties;
	}
}
