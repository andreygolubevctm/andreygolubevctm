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

	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger(FatalErrorDao.class.getName());

	public void add(FatalError fatalError) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		try {
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
						"INSERT INTO test.fatal_error_log (styleCodeId, property, page, message, description, data, datetime, session_id, transaction_id, isFatal) " +
						"VALUES " +
						"(?,?,?,?,?,?,Now(),?,?,?);"
				);
				stmt.setInt(1, fatalError.getStyleCodeId());
				stmt.setString(2, fatalError.getProperty());
				stmt.setString(3, fatalError.getpage());
				stmt.setString(4, fatalError.getmessage());
				stmt.setString(5, fatalError.getDescription());
				stmt.setString(6, fatalError.getData());
				stmt.setString(7, fatalError.getSessionId());
				stmt.setString(8, fatalError.getTransactionId());
				stmt.setString(9, fatalError.getFatal());
			}
		} catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
	}

}
