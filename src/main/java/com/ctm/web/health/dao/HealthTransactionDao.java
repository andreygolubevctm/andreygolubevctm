package com.ctm.web.health.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthTransaction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.ctm.logging.LoggingArguments.kv;

public class HealthTransactionDao {

	private static final String PRODUCT_TITLE_XPATH = "health/application/productTitle";
	public static final String PROVIDER_XPATH = "health/application/provider";
	private static final Logger LOGGER = LoggerFactory.getLogger(HealthTransactionDao.class);


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
		boolean found = false;

		try {
			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT IF(TransID > 0, 1, 0) AS isConfirmed, confirm.keyID AS confirmationKey, td1.textValue AS productTitle, td2.textValue AS provider " +
				"FROM aggregator.transaction_header th " +
				"LEFT JOIN ctm.confirmations confirm ON th.TransactionId = confirm.TransID " +
				"LEFT JOIN aggregator.transaction_details AS td1 " +
				"	ON td1.transactionId = th.transactionId AND td1.xpath = '" + PRODUCT_TITLE_XPATH + "' " +
				"LEFT JOIN aggregator.transaction_details AS td2 " +
				"	ON td2.transactionId = th.transactionId AND td2.xpath = '" + PROVIDER_XPATH + "' " +
				"WHERE th.TransactionId = ?"
			);
			stmt.setLong(1, details.getTransactionId());

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				mapHealthDetails(details, results);
				found = true;
			}

			results.close();
			stmt.close();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
		if(!found){
			getHealthDetailsColdTable(details);
		}

		return details;
	}

	private HealthTransaction getHealthDetailsColdTable(HealthTransaction details) throws DaoException {

		String sql = "SELECT IF(TransID > 0, 1, 0) AS isConfirmed, confirm.keyID AS confirmationKey, " +
				"td1.textValue AS productTitle, td2.textValue AS provider " +
				"FROM aggregator.transaction_header2_cold th " +
				"LEFT JOIN ctm.confirmations confirm ON th.TransactionId = confirm.TransID " +
				"LEFT JOIN aggregator.transaction_details2_cold td1 " +
				"ON td1.transactionId = th.transactionId " +
				"AND td1.fieldId = ( " +
					"SELECT  tf.fieldId " +
					"FROM aggregator.transaction_fields tf " +
					"WHERE tf.fieldCode = '" + PRODUCT_TITLE_XPATH+"' " +
				") " +
				"LEFT JOIN aggregator.transaction_details2_cold td2 " +
				"ON td2.transactionId = th.transactionId " +
				"AND td2.fieldId = ( " +
					"SELECT tf.fieldId " +
					"FROM aggregator.transaction_fields tf " +
					"WHERE tf.fieldCode = '" + PROVIDER_XPATH + "' " +
				") " +
				"WHERE th.TransactionId = ?;";

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(sql);
			stmt.setLong(1, details.getTransactionId());

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				mapHealthDetails(details, results);
			}

			results.close();
			stmt.close();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return details;
	}

	private void mapHealthDetails(HealthTransaction details, ResultSet results) throws SQLException {
		details.setIsConfirmed(results.getBoolean("isConfirmed"));
		details.setConfirmationKey(results.getString("confirmationKey"));
		details.setSelectedProductTitle(results.getString("productTitle"));
		details.setSelectedProductProvider(results.getString("provider"));
	}


	/**
	 * Write error codes to the aggregator.transaction_details table
	 *
	 * @param transactionId
	 * @param errors value to write
	 */
	public void writeAllowableErrors(Long transactionId , String errors) throws DaoException {

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		PreparedStatement stmt = null;

		try {
			stmt = dbSource.getConnection().prepareStatement(
				"INSERT INTO aggregator.transaction_details " +
				"(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) " +
				"values (?, ?, ?, ?,default, now()); "
			);
			stmt.setLong(1, transactionId!=null?0:transactionId);
			stmt.setInt(2, HealthTransactionSequenceNo.ALLOWABLE_ERRORS);
			stmt.setString (3, "health/allowedErrors");
			stmt.setString(4, errors);

			stmt.executeUpdate();
		} catch (NamingException | SQLException e) {
			throw new DaoException(e);
		} finally {
			if(stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					LOGGER.error("Failed to close health transaction db connection {}", kv("errors", errors), e);
				}
			}
			dbSource.closeConnection();
		}
	}
}
