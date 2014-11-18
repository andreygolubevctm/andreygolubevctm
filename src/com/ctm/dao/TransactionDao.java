package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Transaction;

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

		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT th.rootId, LOWER(th.ProductType) AS vertical, th.styleCodeId, styleCodeName,  EmailAddress " +
				"FROM aggregator.transaction_header th " +
				"LEFT JOIN ctm.stylecodes style ON style.styleCodeId = th.styleCodeId " +
				"WHERE TransactionId = ?"
			);
			stmt.setLong(1, transaction.getTransactionId());

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				transaction.setRootId(results.getLong("rootId"));
				transaction.setVerticalCode(results.getString("vertical"));
				transaction.setStyleCodeId(results.getInt("styleCodeId"));
				transaction.setStyleCodeName(results.getString("styleCodeName"));
				transaction.setEmailAddress(results.getString("EmailAddress"));
			}

			results.close();
			stmt.close();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
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
				"SELECT rootId FROM aggregator.transaction_header WHERE TransactionId = ?"
			);
			stmt.setLong(1, transactionId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				rootId = results.getLong("rootId");
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
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
	 * @param ransaction transaction
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
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

}
