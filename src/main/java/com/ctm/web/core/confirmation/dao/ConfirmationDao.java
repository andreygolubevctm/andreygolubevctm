package com.ctm.web.core.confirmation.dao;

import com.ctm.web.core.confirmation.model.Confirmation;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;
import org.springframework.stereotype.Component;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

@Component
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

	/**
	 * Get a confirmation using the confirmation key (token)
	 * @param confirmationKey
	 */
	public Optional<Confirmation> getByKey(String confirmationKey, Long transactionId) throws DaoException {
		Confirmation confirmation = null;

		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT TransID, keyID, Time, XMLdata " +
							"FROM ctm.confirmations " +
							"WHERE keyID = ? " +
							"AND TransID = ?;"
			);
			stmt.setString(1, confirmationKey);
			stmt.setLong(2, transactionId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				confirmation = new Confirmation();
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

		return Optional.ofNullable(confirmation);
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
		new SqlDao().update(databaseMapping);
	}
}
