package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.FatalError;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class FatalErrorDao {

	private static final Logger logger = LoggerFactory.getLogger(FatalErrorDao.class.getName());

	public void add(FatalError fatalError) throws DaoException {
		String data = getData(fatalError);
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
						"INSERT INTO aggregator.fatal_error_log " +
						"(styleCodeId, property, page, message, description, data, datetime, session_id, transaction_id, isFatal) " +
						"VALUES " +
						"(?,?,?,?,?,?,Now(),?,?,?);"
				);
				stmt.setInt(1, fatalError.getStyleCodeId());
				stmt.setString(2, fatalError.getProperty());
				stmt.setString(3, fatalError.getpage());
				stmt.setString(4, fatalError.getmessage());
				stmt.setString(5, fatalError.getDescription());
				stmt.setString(6, data);
				stmt.setString(7, fatalError.getSessionId());
				stmt.setString(8, fatalError.getTransactionId());
				stmt.setString(9, fatalError.getFatal());

				stmt.executeUpdate();
			}
		} catch (SQLException | NamingException e) {
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}
	}

	private String getData(FatalError fatalError) {
		String data = fatalError.getData();
		// Max length for mysql text field is 65535
		if(data != null && data.length() > 65535) {
			logger.warn("fatal error data too long truncating data={}", data);
			data = data.substring(0, data.length() - 65535);
		}
		return data;
	}

}
