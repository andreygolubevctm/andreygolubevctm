package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import org.apache.log4j.Logger;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SqlDao<T> {
	
	private static final Logger logger = Logger.getLogger(SqlDao.class.getName());
	
	private final SimpleDatabaseConnection databaseConnection;
	private final String context;
	private PreparedStatement stmt;
	private Connection conn;
    private boolean autoCommit;

    public SqlDao() {
		databaseConnection = SimpleDatabaseConnection.getInstance();
		this.context = "jdbc/ctm";
	}


    /**
     * Run a sequence of updates in a single transaction
     * If any transactions fail all transactions will be rolled back
     * @param databaseMappings chain of updates to call
     * @throws DaoException updates will have rolled back
     */
    public void updateChain(List<DatabaseUpdateMapping> databaseMappings) throws DaoException {
        // Run update for each mapping
        for(DatabaseUpdateMapping databaseMapping :  databaseMappings){
            updateAsPartOfTransaction(databaseMapping);
        }
        // No exceptions have occurred so commit transaction
        commitTransaction();
    }

    /**
     * IMPORTANT: this will leave an open connection so it is very important to call either commitTransaction() or rollback()
     * When the transaction is complete
     * call commitTransaction() after all transactions have been completed successfully
     * call rollback() to roll back if issues occur exceptions in this method will autmatically rollback
     * @param databaseMapping
     * @throws DaoException
     */
    public void updateAsPartOfTransaction(DatabaseUpdateMapping databaseMapping) throws DaoException {
        try {
            if(conn == null || conn.isClosed()) {
                startTransaction();
            }
            stmt = conn.prepareStatement(databaseMapping.getStatement());
            databaseMapping.handleParams(stmt);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            rollback();
            logger.error(e);
            throw new DaoException("Error when performing update" , e);
        }
    }

    /**
     * Call this after updateAsPartOfTransaction
     */
    public void commitTransaction() throws DaoException {
        try {
            conn.commit();
        } catch (SQLException e) {
            throw new DaoException("Failed to commit transaction" , e);
        }
        cleanup(autoCommit);
    }

    /**
     * Call this after updateAsPartOfTransaction if commitTransaction() has not been called and you want to roll back changes
     */
    public void rollback() throws DaoException {
        try {
            if(conn != null){
                conn.rollback();
            }
        } catch (SQLException e) {
            throw new DaoException("Failed to roll back connection" , e);
        }
        cleanup(autoCommit);
    }

    public int update(DatabaseUpdateMapping databaseMapping) throws DaoException {
		try {
			conn = databaseConnection.getConnection(context, true);
			stmt = conn.prepareStatement(databaseMapping.getStatement());
			databaseMapping.handleParams(stmt);
			return stmt.executeUpdate();
		} catch (SQLException | NamingException e) {
			logger.error(e);
			throw new DaoException("failed to executeUpdate " + databaseMapping.getStatement(), e);
		} finally {
			cleanup();
		}
	}

    /**
     * Method to handle some of the JDBC logic
     * @param databaseMapping logic to handle setting params and retrieving results
     * @param sql select statement
     * @return T a model from the database which is mapped in databaseMapping
     * @throws DaoException a wrapper of SQLException and NamingException
     */
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

	public List<T> getList(DatabaseQueryMapping<T> databaseMapping, String sql) throws DaoException {
		List<T>  list = new ArrayList<>();
		try {
			ResultSet rs = executeQuery(databaseMapping, sql);
			while (rs.next()) {
				list.add(databaseMapping.handleResult(rs));
			}
			rs.close();
		} catch (SQLException  e) {
			logger.error(e);
			throw new DaoException("failed to getResult " + sql, e);
		} finally {
			cleanup();
		}
		return list;
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

    private void cleanup() {
        databaseConnection.closeConnection(conn, stmt);
    }

    private void cleanup(boolean autocommit) {
        try {
            if(conn != null && !conn.isClosed()) {
                conn.setAutoCommit(autocommit);
            }
        } catch (SQLException e) {
            logger.error(e);
        }
        cleanup();
    }


    private void startTransaction() throws SQLException, NamingException {
        conn = databaseConnection.getConnection(context, true);
        autoCommit = conn.getAutoCommit();
        conn.setAutoCommit(false);
    }

    private ResultSet executeQuery(DatabaseQueryMapping<T> databaseMapping,
                                   String sql) throws DaoException {
        try {
            conn = databaseConnection.getConnection(context, true);
            stmt = conn.prepareStatement(sql);
            databaseMapping.handleParams(stmt);
            return stmt.executeQuery();
        } catch (SQLException | NamingException e) {
            throw new DaoException("Query failed sql" + sql , e);
        }
    }

    /**
     * clean up any outstanding connections developer note there really shouldn't be any open connections
     */
    @Override
    protected void finalize() throws Throwable {
        boolean doCleanUp = false;
        try {
            if(conn != null && !conn.isClosed()) {
                logger.error("Connection was not closed! manually closing now ");
                doCleanUp = true;
            }
            if(stmt != null && !stmt.isClosed()) {
                logger.error("Statement was not closed! manually closing now ");
                doCleanUp = true;
            }
        } catch (SQLException e) {}
        if(doCleanUp) {
            cleanup(autoCommit);
        }
        super.finalize();
    }
}
