package com.ctm.web.core.dao.transaction;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Transaction;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TransactionDao {

	/**
	 * Populates details: rootId, vertical, styleCodeId, styleCodeName.
	 * @param transaction The model that will have details added to
	 * @return Updated model
	 */
	public Transaction getCoreInformation(Transaction transaction) throws DaoException {

		if (transaction == null || transaction.getTransactionId() == 0) {
			throw new DaoException("Please specify a transactionId on your model.");
		}

		transaction.setRootId(getRootIdOfTransactionId(transaction.getTransactionId()));

		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT LOWER(th.ProductType) AS vertical, th.styleCodeId, style.styleCode AS styleCodeName, " +
				"th.EmailAddress, MAX(th.transactionId) AS newestTransactionId " +
				"FROM aggregator.transaction_header th " +
				"LEFT JOIN ctm.stylecodes style ON style.styleCodeId = th.styleCodeId " +
				"WHERE th.rootId = ? " +
				"UNION ALL " +
				"SELECT LOWER(vm.verticalCode) AS vertical, th.styleCodeId, style.styleCode AS styleCodeName, " +
				"em.emailAddress, MAX(th.transactionId) AS newestTransactionId " +
				"FROM aggregator.transaction_header2_cold th " +
				"LEFT JOIN ctm.vertical_master vm ON vm.verticalId = th.verticalId " +
				"LEFT JOIN ctm.stylecodes style ON style.styleCodeId = th.styleCodeId " +
				"LEFT JOIN aggregator.transaction_emails te ON te.TransactionId = th.TransactionId " +
				"LEFT JOIN aggregator.email_master em ON em.emailId = te.emailId " +
				"WHERE th.rootId = ? " +
				"ORDER BY newestTransactionId ASC;"
			);
			stmt.setLong(1, transaction.getRootId());
			stmt.setLong(2, transaction.getRootId());

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				transaction.setNewestTransactionId(results.getLong("newestTransactionId"));
				transaction.setVerticalCode(results.getString("vertical"));
				transaction.setStyleCodeId(results.getInt("styleCodeId"));
				transaction.setStyleCodeName(results.getString("styleCodeName"));
				transaction.setEmailAddress(results.getString("EmailAddress"));
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

		return transaction;
	}

	/**
	 * Get the root ID of the provided transaction ID.
	 * @param transactionId
	 * @return Root ID of the provided transaction ID
	 */
	public long getRootIdOfTransactionId(long transactionId) throws DaoException {

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		long rootId = 0;

		try {
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT rootId FROM aggregator.transaction_header WHERE TransactionId = ? " +
				"UNION ALL " +
				"SELECT rootId FROM aggregator.transaction_header2_cold WHERE TransactionId = ?;"
			);
			stmt.setLong(1, transactionId);
			stmt.setLong(2, transactionId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				rootId = results.getLong("rootId");
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		if (rootId == 0) {
			throw new DaoException("Unable to find rootId of transactionId " + transactionId);
		}

		return rootId;
	}

	/**
	 * Update transaction header with the new email address
	 * @param transaction transaction
	 */
	public void writeEmailAddress(Transaction transaction) throws DaoException {
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE aggregator.transaction_header " +
				"SET EmailAddress = ? " +
				"WHERE TransactionId = ?;"
			);
			stmt.setString(1, transaction.getEmailAddress());
			stmt.setLong(2, transaction.getTransactionId());

			stmt.executeUpdate();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	public Long getMostRecentRelatedTransactionId(long transactionId) throws DaoException {
		long relatedTransactionId = 0;
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT MAX(TransactionId) AS transactionId " +
					"FROM aggregator.transaction_header " +
					"WHERE PreviousId=?;"
			);
			stmt.setLong(1, transactionId);
			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				long relatedTransactionIdTemp = results.getLong("transactionId");
				if(relatedTransactionIdTemp != 0 && relatedTransactionIdTemp != relatedTransactionId) {
					relatedTransactionId = relatedTransactionIdTemp;
					stmt.setLong(1, relatedTransactionId);
					results = stmt.executeQuery();
				}
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
		if(relatedTransactionId == 0) {
			relatedTransactionId = transactionId;
		}

		return relatedTransactionId;
	}

}
