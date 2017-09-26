package com.ctm.web.core.transaction.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.model.Transaction;
import com.ctm.web.core.utils.common.utils.StringUtils;
import com.ctm.web.simples.model.ConfirmationOperator;
import org.springframework.stereotype.Component;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Component
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
	 * Check the transactions chained from the provided RootId and find any confirmation (sold) information.
	 * @return Valid object or null
	 */
	public ConfirmationOperator getConfirmationFromTransactionChain(List<Long> rootIds) throws DaoException {
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		if (rootIds == null || rootIds.isEmpty()) {
			return null;
		}
		try {
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"Select transactionId, operator_id, CONCAT(date, ' ', time)  AS datetime from ( " +
							"	SELECT th.transactionId, tc.operator_id, tc.date, tc.time " +
							"	FROM aggregator.transaction_header th " +
							"	JOIN ctm.touches tc ON th.transactionID = tc.transaction_Id AND tc.`type` = 'C' " +
							"	WHERE rootID in ( " + StringUtils.sqlQuestionMarkStringBuilder(rootIds.size()) + " ) " +
							"	UNION ALL " +
							"	SELECT th.transactionId, tc.operator_id, tc.`date`, tc.`time` " +
							"	FROM aggregator.transaction_header2_cold th " +
							"	JOIN ctm.touches tc ON th.transactionID = tc.transaction_Id AND tc.`type` = 'C' " +
							"	WHERE rootID in ( " + StringUtils.sqlQuestionMarkStringBuilder(rootIds.size()) + " )" +
							")a ORDER  BY date DESC ,time desc;"
			);
			int i=1;
			for (long rootId : rootIds) {
				stmt.setLong(i++,rootId);
			}
			for (long rootId : rootIds) {
				stmt.setLong(i++,rootId);
			}

			ResultSet results = stmt.executeQuery();

			if (results.next()) {
				ConfirmationOperator confirmationOperator = new ConfirmationOperator();
				confirmationOperator.setTransactionId(results.getLong("transactionId"));
				confirmationOperator.setOperator(results.getString("operator_id"));
				confirmationOperator.setDatetime(results.getTimestamp("datetime"));
				return confirmationOperator;
			}
		} catch (SQLException | NamingException e) {
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return null;
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

	public boolean transactionIdExists(long transactionId) throws DaoException {

	    boolean exists = false;

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT TransactionId AS 'transactionId' FROM aggregator.transaction_header WHERE TransactionId = ? " +
					"UNION ALL " +
					"SELECT transactionId FROM aggregator.transaction_header2_cold WHERE transactionId = ?;"
			);

			stmt.setLong(1, transactionId);
			stmt.setLong(2, transactionId);

			ResultSet results = stmt.executeQuery();

			exists = results.next();
		}
		catch (SQLException | NamingException e) {
        	throw new DaoException(e);
		}
		finally {
            dbSource.closeConnection();
		}

		return exists;
	}

	/**
	 * Get latest transaction id given root id
	 * @param rootId
	 * @return Latest transaction id given root id
	 */
	public long getLatestTransactionIdByRootId(final long rootId) throws DaoException {

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		long transactionId = 0;
		try {
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT MAX(transactionId) as transactionId FROM aggregator.transaction_header WHERE rootId = ? " +
							"UNION ALL " +
							"SELECT MAX(transactionId) as transactionId FROM aggregator.transaction_header2_cold WHERE rootId = ?;"
			);
			stmt.setLong(1, rootId);
			stmt.setLong(2, rootId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				transactionId = results.getLong("transactionId");
				if(transactionId != 0) {
					break;
				}
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		if (transactionId == 0) {
			throw new DaoException("Unable to find latest transaction id of rootId " + rootId);
		}

		return transactionId;
	}

}
