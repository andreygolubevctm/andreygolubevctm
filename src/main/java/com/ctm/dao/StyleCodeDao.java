package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.logging.LoggingArguments.kv;

public class StyleCodeDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(StyleCodeDao.class);

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

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve styleCodeId {}", kv("transactionId", transactionId));
			throw new DaoException(e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}

		return styleCodeId;
	}

}
