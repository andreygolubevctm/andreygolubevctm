package com.ctm.dao.health;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthTransaction;

public class HealthTransactionDao {

	private static Logger logger = Logger.getLogger(HealthTransactionDao.class.getName());


	public static class HealthTransactionSequenceNo {
		public static final int ALLOWABLE_ERRORS = -8;
		// TODO: At the moment this is just informative. Use these in the code base.
		public static final int POLICY_NUMBER = -2;
		public static final int CONFIRMATION_EMAIL_CODE = -1;
	}

	/**
	 * Populates details: isConfirmed, confirmationKey, selectedProductTitle, selectedProductProvider
	 * @param details The model that will have details added to
	 * @return Updated model
	 */
	public HealthTransaction getHealthDetails(HealthTransaction details) throws DaoException {

		if (details == null || details.getTransactionId() == 0) {
			throw new DaoException("Please specify a transactionId on your model.");
		}

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			PreparedStatement stmt;
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

	/**
	 * Write error codes to the aggregator.transaction_details table
	 *
	 * @param transactionId
	 * @param errors value to write
	 */
	public void writeAllowableErrors(int transactionId , String errors) throws DaoException {

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		PreparedStatement stmt = null;

		try {
			stmt = dbSource.getConnection().prepareStatement(
				"INSERT INTO aggregator.transaction_details " +
				"(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) " +
				"values (?, ?, ?, ?,default, now()); "
			);
			stmt.setLong(1, transactionId);
			stmt.setInt(2, HealthTransactionSequenceNo.ALLOWABLE_ERRORS);
			stmt.setString (3, "health/allowedErrors");
			stmt.setString(4, errors);

			stmt.executeUpdate();
		} catch (NamingException e) {
			throw new DaoException("Failed to write allowable errors. Errors: " + errors , e);
		} catch (SQLException e) {
			throw new DaoException("Failed to write allowable errors. Errors: " + errors , e);
		} finally {
			if(stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					logger.error(e);
				}
			}
			dbSource.closeConnection();
		}
	}
}
