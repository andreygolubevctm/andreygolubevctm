package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.dao.transaction.DatabaseQueryMapping;
import com.ctm.exceptions.DaoException;
import org.apache.log4j.Logger;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SqlDao<T> {
	
	private static final Logger logger = Logger.getLogger(SqlDao.class.getName());
	
	private final SimpleDatabaseConnection databaseConnection;
	private final String context;
	private PreparedStatement stmt;
	
	public SqlDao() {
		databaseConnection = new SimpleDatabaseConnection();
		this.context = "jdbc/ctm";
	}

	public void insert(DatabaseUpdateMapping databaseMapping, String sql) throws DaoException {
		try {
			Connection conn = databaseConnection.getConnection(context);
			stmt = conn.prepareStatement(sql);
			databaseMapping.handleParams(stmt);
			stmt.executeUpdate();
		} catch (SQLException | NamingException e) {
			logger.error(e);
			throw new DaoException("failed to executeUpdate " + sql, e);
		} finally {
			cleanup();
		}
	}

	private void cleanup() {
		if(stmt != null){
            try {
                stmt.close();
            } catch (SQLException e) {
                logger.error(e);
            }
        }
		databaseConnection.closeConnection();
	}

	public T get(DatabaseQueryMapping<T> databaseMapping, String sql) throws DaoException {
		long startTime = System.currentTimeMillis();
		T value = null;
		try {
			ResultSet rs = executeQuery(databaseMapping, sql);
			while (rs.next()) {
				value = databaseMapping.handleResult(rs);
			}
			rs.close();
		} catch (SQLException  e) {
			logger.error(e);
			throw new DaoException("failed to getResult " + sql, e);
		} finally {
			cleanup();
		}
		logger.debug("Total execution time: " + (System.currentTimeMillis()-startTime) + "ms");
		return value;
	}

	private ResultSet executeQuery(DatabaseQueryMapping<T> databaseMapping,
								   String sql) throws DaoException {
		try {
			Connection conn = databaseConnection.getConnection(context);
			stmt = conn.prepareStatement(sql);
			databaseMapping.handleParams(stmt);
			return stmt.executeQuery();
		} catch (SQLException | NamingException e) {
			throw new DaoException("Query failed sql" + sql , e);
		}
	}


	public void update(String sql) throws DaoException {
		try {
			Connection conn = databaseConnection.getConnection(context);
			stmt = conn.prepareStatement(sql);
			stmt.executeUpdate();
		} catch (SQLException | NamingException e) {
			logger.error(e);
			throw new DaoException("failed to executeUpdate " + sql, e);
		} finally {
			cleanup();
		}
	}
}
