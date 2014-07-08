package com.ctm.dao.health;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthTransaction;

public class HealthTransactionDao {

	/**
	 * Populates details: isConfirmed, confirmationKey, selectedProductTitle, selectedProductProvider
	 * @param details The model that will have details added to
	 * @return Updated model
	 */
	public HealthTransaction getHealthDetails(HealthTransaction details) throws DaoException {

		if (details == null || details.getTransactionId() == 0) {
			throw new DaoException("Please specify a transactionId on your model.");
		}

		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT IF(TransID > 0, 1, 0) AS isConfirmed, confirm.keyID AS confirmationKey, td1.textValue AS productTitle, td2.textValue AS provider " +
				"FROM aggregator.transaction_header th " +
				"LEFT JOIN ctm.confirmations confirm ON th.TransactionId = confirm.TransID " +
				"LEFT JOIN aggregator.transaction_details AS td1 " +
				"	ON td1.transactionId = th.transactionId AND td1.xpath = 'health/application/productTitle' " +
				"LEFT JOIN aggregator.transaction_details AS td2 " +
				"	ON td2.transactionId = th.transactionId AND td2.xpath = 'health/application/provider' " +
				"WHERE th.TransactionId = ?"
			);
			stmt.setLong(1, details.getTransactionId());

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				details.setIsConfirmed(results.getBoolean("isConfirmed"));
				details.setConfirmationKey(results.getString("confirmationKey"));
				details.setSelectedProductTitle(results.getString("productTitle"));
				details.setSelectedProductProvider(results.getString("provider"));
			}

			results.close();
			stmt.close();
		}
		catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		}
		catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return details;
	}

}
