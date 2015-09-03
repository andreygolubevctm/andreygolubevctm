package com.ctm.dao.simples;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.simples.MessageOverview;

public class MessageOverviewDao {

	/**
	 */
	public MessageOverview getMessageOverview() throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		MessageOverview messageOverview = new MessageOverview();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			//
			// Execute the stored procedure for message details
			//
			stmt = dbSource.getConnection().prepareStatement(
				"CALL simples.message_overview();"
			);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				messageOverview.setCurrent(results.getInt("current"));
				messageOverview.setFuture(results.getInt("future"));
				messageOverview.setCompleted(results.getInt("completed"));
				messageOverview.setExpired(results.getInt("expired"));
				messageOverview.setPending(results.getInt("pending"));
				messageOverview.setPostponed(results.getInt("postponed"));
			}
		}
		catch (SQLException e) {
			throw new DaoException(e);
		}
		catch (NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return messageOverview;
	}

}
