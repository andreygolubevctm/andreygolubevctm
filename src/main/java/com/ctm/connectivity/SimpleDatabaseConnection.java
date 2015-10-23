package com.ctm.connectivity;

import com.ctm.exceptions.EnvironmentException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class SimpleDatabaseConnection implements AutoCloseable {

	private static final Logger LOGGER = LoggerFactory.getLogger(SimpleDatabaseConnection.class);

	public static final String JDBC_CTM = "jdbc/ctm";

	private Connection connection;
	private Map<String ,DataSource> dataSources = new HashMap<>();

	private static SimpleDatabaseConnection instance;
	private static Context envCtx;

	public static SimpleDatabaseConnection getInstance() {
		if(instance == null){
			instance = new SimpleDatabaseConnection();
		}
		return instance;
	}

	public Connection getConnection() throws SQLException, NamingException {
		return getConnection(JDBC_CTM);
	}

	public Connection getConnection(boolean fresh) throws SQLException, NamingException {
		return getConnection(JDBC_CTM , fresh);
	}
	
	public Connection getConnection(String context) throws SQLException, NamingException {
		return getConnection(context , false);
	}

	public Connection getConnection(String context , boolean fresh) throws SQLException, NamingException {
		if(dataSources.get(context) == null) {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			dataSources.put(context ,(DataSource) envCtx.lookup(context));
		}
		if(fresh) {
			return dataSources.get(context).getConnection();
		} else {
			if(connection == null || connection.isClosed()) {
				setConnection(dataSources.get(context).getConnection());
			}
			return connection;
		}
	}

	@Override
	public void close() throws Exception {
		closeConnection();
	}

	public void closeConnection() {
		try {
			if(this.connection != null && !this.connection.isClosed()){
				this.connection.close();
			}
		} catch (SQLException e) {
			LOGGER.error("Failed to close db connection", e);
		}
	}

	public void closeConnection(Connection connection, Statement statement) {
		closeStatement(statement);
		try {
			if(connection != null && !connection.isClosed()){
				connection.close();
			}
		} catch (SQLException e) {
			LOGGER.error("Failed to close db connection", e);
		}
	}

	public void closeStatement(Statement statement) {
		try {
			if(statement != null && !statement.isClosed()){
				statement.close();
			}
		} catch (SQLException e) {
			LOGGER.error("Failed to close statement", e);
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

	public static DataSource getDataSourceJdbcCtm() {
		DataSource ds;
		if (envCtx == null) {
			try {
				Context initCtx = new InitialContext();
				envCtx = (Context)initCtx.lookup("java:comp/env");
			} catch (NamingException ne) {
				LOGGER.error("Failed to lookup initialcontext", ne);
				throw new EnvironmentException("Failed to lookup initialcontext");
			}
		}

		try {
			ds = (DataSource)envCtx.lookup(JDBC_CTM);
		} catch (NamingException ne) {
			LOGGER.error("Failed to lookup environmental jdbc context",ne);
			throw new EnvironmentException("Failed to lookup environmental jdbc context");
		}

		return ds;
	}
}
