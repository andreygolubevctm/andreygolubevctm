package com.ctm.connectivity;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

public class SimpleDatabaseConnection {

	private static Logger logger = Logger.getLogger(SimpleDatabaseConnection.class.getName());

	private Connection connection;
	private DataSource ds;

	public SimpleDatabaseConnection() throws NamingException {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		ds = (DataSource) envCtx.lookup("jdbc/ctm");
	}

	public Connection getConnection() throws SQLException {
		if(connection == null || connection.isClosed()) {
			setConnection(ds.getConnection());
		}
		return connection;
	}

	public void closeConnection() {
		try {
			if(connection != null && !connection.isClosed()){
				connection.close();
			}
		} catch (SQLException e) {
			logger.error("failed to close connection", e);
		}
	}

	private void setConnection(Connection connection) {
		this.connection = connection;
	}

	public static String createSqlArrayParams(int numParams) {
		StringBuilder sb = new StringBuilder();
		if(numParams <= 0) return sb.toString();
		for(int i = 0; i < numParams - 1; i++) {
			sb.append("?,");
		}
		sb.append("?");
		return sb.toString();
	}
}
