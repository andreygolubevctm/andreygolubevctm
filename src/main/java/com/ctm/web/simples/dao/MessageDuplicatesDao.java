package com.ctm.web.simples.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.model.Message;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MessageDuplicatesDao {
	/**
	 * Sets value of transactionId in message object that is mapped with messageId(variable of supplied message object) in the database
	 * @param message
	 * @throws DaoException
	 */
	public void setDupeTransactionIds(Message message) throws DaoException {

		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT transactionId FROM simples.message_duplicates " +
				"WHERE messageId = ? "
			);
			stmt.setInt(1, message.getMessageId());
			final ResultSet results = stmt.executeQuery();

			while (results.next()) {
				message.addDupeTransactionId(results.getLong("transactionId"));
			}

		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	/**
	 * Get all the transactionIDs that are mapped with the message Id in the simples.message_duplicates table
	 * @param messageId
	 * @return
	 * @throws DaoException
	 */
	public List<Long> getTransactionIDs(int messageId) throws DaoException {
		List<Long> transactionIds = new ArrayList<>();
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT transactionId FROM simples.message_duplicates " +
							"WHERE messageId = ? "
			);
			stmt.setInt(1, messageId);
			final ResultSet results = stmt.executeQuery();

			while (results.next()) {
				transactionIds.add(results.getLong("transactionId"));
			}

		} catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
		return transactionIds;
	}
}
