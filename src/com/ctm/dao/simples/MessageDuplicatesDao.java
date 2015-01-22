package com.ctm.dao.simples;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.simples.Message;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MessageDuplicatesDao {

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
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}
}
