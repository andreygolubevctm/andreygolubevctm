package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.FatalError;

public class FatalErrorDao {

	private static Logger logger = Logger.getLogger(FatalErrorDao.class.getName());

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
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}
	}

	private String getData(FatalError fatalError) {
		String data = fatalError.getData();
		// Max length for mysql text field is 65535
		if(data != null && data.length() > 65535) {
			logger.info("truncating data:" + data);
			data = data.substring(0, data.length() - 65535);
		}
		return data;
	}

}
