package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

public class StyleCodeDao {

	public int getStyleCodeId(long transactionId) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		int styleCodeId = 0;

		try{

			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT styleCodeID FROM ctm.transaction_stylecode where transactionID = ?"
			);
			stmt.setLong(1, transactionId);

			ResultSet resultSet = stmt.executeQuery();

			while (resultSet.next()) {
				styleCodeId = resultSet.getInt("styleCodeID");
			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}

		return styleCodeId;
	}

}
