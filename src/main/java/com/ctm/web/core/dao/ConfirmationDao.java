package com.ctm.web.core.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.Confirmation;

public class ConfirmationDao {

	/**
	 * Get a confirmation using the confirmation key (token)
	 * @param confirmationKey
	 */
	public Confirmation getByKey(String confirmationKey) throws DaoException {
		Confirmation confirmation = new Confirmation();

		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT TransID, keyID, Time, XMLdata " +
				"FROM ctm.confirmations " +
				"WHERE keyID = ?"
			);
			stmt.setString(1, confirmationKey);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				confirmation.setTransactionId(results.getLong("TransID"));
				confirmation.setKey(results.getString("keyID"));
				confirmation.setDatetime(results.getTimestamp("Time"));
				confirmation.setXmlData(results.getString("xmlData"));
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

		return confirmation;
	}
}
