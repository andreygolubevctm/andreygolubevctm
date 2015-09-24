package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Confirmation;

public class ConfirmationDao {

	private final SqlDao sqlDao;

	public ConfirmationDao() {
		this.sqlDao = new SqlDao();
	}

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

	public void addConfirmation(Confirmation confirmation) throws DaoException {
		DatabaseUpdateMapping databaseMapping = new DatabaseUpdateMapping(){
			@Override
			public void mapParams() throws SQLException {
				set(confirmation.getTransactionId());
				set(confirmation.getKey());
				set(confirmation.getXmlData());
			}

			@Override
			public String getStatement() {
				return "INSERT INTO ctm.`confirmations` " +
						"(TransID, KeyId, Time, XMLdata) VALUES (?, ?, NOW(), ?);";
			}
		};
		sqlDao.update(databaseMapping);
	}
}
